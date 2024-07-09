import pathlib
import textwrap
import os

import google.generativeai as genai
from dotenv import load_dotenv,find_dotenv


# load_dotenv()

# GOOGLE_API_KEY=os.getenv('GOOGLE_API_KEY')

# genai.configure(api_key=GOOGLE_API_KEY)

# model = genai.GenerativeModel('gemini-pro')

def summarize(text,key):
    GOOGLE_API_KEY=key
    print(GOOGLE_API_KEY)
    genai.configure(api_key=GOOGLE_API_KEY)

    model = genai.GenerativeModel('gemini-pro')

    prompt_summarize = textwrap.dedent(
    """
    Summarize the following text into bullet points , which doesn't exceed 200 words and don't use markdown :
    %s
    """
    ) % text
    response = model.generate_content(prompt_summarize)
    generated_content = response.candidates[0].content.parts[0].text

    print(generated_content)
    return generated_content

