import os
import tempfile
from fastapi import FastAPI, File, UploadFile, HTTPException
from fastapi.middleware.cors import CORSMiddleware
import openai
import logging

# Import the correct exception
from openai import OpenAIError


# Initialize logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Initialize FastAPI app
app = FastAPI(
    title="Audio Notes Transcription API",
    description="API to transcribe audio files and generate notes using OpenAI's Whisper and ChatGPT.",
    version="1.0.0",
)

# Configure CORS
origins = [
    "http://localhost",
    "http://localhost:3000",
    # Add other origins you want to allow
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,  # Allows specific origins
    allow_credentials=True,
    allow_methods=["*"],  # Allows all HTTP methods
    allow_headers=["*"],  # Allows all headers
)

# Set your OpenAI API key
# It's recommended to set this as an environment variable for security
OPENAI_API_KEY = os.getenv("OPENAI_API_KEY", "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")
openai.api_key = OPENAI_API_KEY

@app.post("/api/transcribe", summary="Transcribe audio and generate notes")
async def transcribe_audio(file: UploadFile = File(...)):
    logger.info(f"Received file: {file.filename}, Content-Type: {file.content_type}")
    
    # Validate file type
    if not file.content_type.startswith("audio/"):
        logger.error(f"Invalid file type: {file.content_type}")
        raise HTTPException(status_code=400, detail="Invalid file type. Please upload an audio file.")

    # Save the uploaded file to a temporary location
    try:
        with tempfile.NamedTemporaryFile(delete=False, suffix=".aac") as temp_file:
            temp_file_path = temp_file.name
            content = await file.read()
            temp_file.write(content)
            logger.info(f"Saved temporary file at: {temp_file_path}")
    except Exception as e:
        logger.exception("Failed to save the uploaded file.")
        raise HTTPException(status_code=500, detail=f"Failed to save the uploaded file. Error: {e}")

    try:
        # Step 1: Transcribe using OpenAI's Whisper (Updated Method)
        logger.info("Starting transcription using OpenAI's Whisper.")
        with open(temp_file_path, "rb") as audio_file:
            transcription = openai.audio.transcriptions.create(
                model="whisper-1",
                file=audio_file,
                response_format="text"
            )
        transcription_text = transcription.strip()
        logger.info(f"Transcription text: {transcription_text}")

        if not transcription_text:
            logger.error("Transcription failed. No text returned.")
            raise HTTPException(status_code=500, detail="Transcription failed. No text returned.")

        # Step 2: Generate notes using ChatGPT
        prompt = f"Create detailed notes in Markdown format from the following transcription:\n\n{transcription_text}"
        logger.info("Generating notes using ChatGPT.")
        chat_response = openai.ChatCompletion.create(
            model="gpt-4",
            messages=[
                {"role": "system", "content": "You are a helpful assistant that creates detailed notes in Markdown format."},
                {"role": "user", "content": prompt}
            ],
            max_tokens=1500,
            temperature=0.5,
        )
        notes = chat_response.choices[0].message['content'].strip()
        logger.info("Notes generation successful.")

        return {"notes": notes}

    except OpenAIError as oe:
        logger.exception("OpenAI API error.")
        raise HTTPException(status_code=500, detail=f"OpenAI API error: {oe}")
    except Exception as e:
        logger.exception("An unexpected error occurred.")
        raise HTTPException(status_code=500, detail=f"An unexpected error occurred: {e}")
    finally:
        # Clean up the temporary file
        try:
            #os.remove(temp_file_path)
            logger.info(f"Removed temporary file at: {temp_file_path}")
        except Exception as e:
            logger.warning(f"Failed to remove temporary file at: {temp_file_path}. Error: {e}")
