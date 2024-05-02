/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const {onRequest} = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");
const functions = require('firebase-functions');

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

// Import dependencies
const { OpenAI } = require('openai');
const openai = new OpenAI({
  apiKey: "sk-proj-t9PlJa7DvePsrtdu2UkFT3BlbkFJat1f2PXO8nu7FDOLBYk5"
});




exports.generateStory = functions.https.onCall(async (data, context) => {
    if (!context.auth) {
        throw new functions.https.HttpsError('failed-precondition', 'The function must be called while authenticated.');
    }

    try {
        const response = await openai.chat.completions.create({
            model: "gpt-3.5-turbo-1106",
            messages: [
            {
                "role": "system",
                "content": "You are going to write a story about the elements given to you. It must either be a funny, spooky, ominous, or care free story; you get to choose. the elements have appeared in the user's life today, and they have seen all of them in the order they type them. each element is presented with an address and also a description of what it is. generate a narrative between the items about how they saw them and their journey today to see all those items. write in first person. you can reference address but do not make it too clunky. if you run out of items, do not come up with any more items and end the story there. DO NOT COME UP WITH EXTRA ITEMS ONLY WRITE ABOUT WHAT IS GIVEN TO YOU"
            },
            {
                "role": "user",
                "content": data.prompt
            },
            
            ],
            temperature: 1,
            max_tokens: 512,
            top_p: 1,
            frequency_penalty: 0,
            presence_penalty: 0,
        });
        console.log(response)
         // Correctly access the generated text
         if (response.choices && response.choices && response.choices.length > 0) {
            return { story: response.choices[0].message.content };
        } else {
            throw new Error("No completion found in response.");

        }
    }
    catch (error) {
        console.error("Error in generating story:", error);
        throw new functions.https.HttpsError('internal', 'Failed to generate story.', error.message);
    }
  });


  