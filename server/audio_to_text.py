# convert audio to text

import speech_recognition as sr

def audio_to_text(audio_file):
    r = sr.Recognizer()
    with sr.AudioFile(audio_file) as source:
        audio_data = r.record(source)
        text = r.recognize_google(audio_data)
        return text

print(audio_to_text('test.mp3')) 
