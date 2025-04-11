import { onSchedule } from "firebase-functions/v2/scheduler";
import * as logger from "firebase-functions/logger";
import * as admin from "firebase-admin";

admin.initializeApp();

export const concoursProgrammee = onSchedule(
  "every 15 minutes",
  async (event) => {
    const db = admin.firestore();
    const joueursSnapshot = await db.collection("joueurs").get();

    let gagnant: any = null;

    for (const joueur of joueursSnapshot.docs) {
      const assemblages = await joueur.ref
        .collection("assemblages")
        .where("soumis", "==", true)
        .get();

      for (const doc of assemblages.docs) {
        const data = doc.data();
        const score =
          (data.gout || 0) +
          (data.amertume || 0) +
          (data.teneur || 0) +
          (data.odorat || 0);

        if (!gagnant || score > gagnant.score) {
          gagnant = {
            userId: joueur.id,
            assemblageId: doc.id,
            score,
          };
        }
      }
    }

    if (gagnant) {
      await db
        .collection("joueurs")
        .doc(gagnant.userId)
        .collection("notifications")
        .add({
          message: "🎉 Vous avez gagné le concours CMTM !",
          date: admin.firestore.FieldValue.serverTimestamp(),
        });

      await db
        .collection("joueurs")
        .doc(gagnant.userId)
        .collection("assemblages")
        .doc(gagnant.assemblageId)
        .update({ gagnant: true });
    }

    logger.info("Concours terminé.");
  }
);
