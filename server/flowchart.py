import pathlib
import textwrap
import os
import re
import google.generativeai as genai
from dotenv import load_dotenv, find_dotenv
from flask import Flask, request, jsonify

app = Flask(__name__)
load_dotenv()

GOOGLE_API_KEY = os.getenv('GOOGLE_API_KEY')

def configure_genai(api_key):
    genai.configure(api_key=api_key)

def generate_mind_map_structure(text,api_key):
    model = genai.GenerativeModel('gemini-pro')
    genai.configure(api_key=api_key)
    prompt_mind_map = textwrap.dedent(
    """
    Can you create a Mermaid diagram to help understand the following text use single letters to denote and don't put heading like mermaid?
    %s
    example template:
    graph TD;
      A[Main Topic]
      A --> B[Subtopic 1]
      B --> C[Detail 1]
      B --> D[Detail 2]
      A --> E[Subtopic 2]
      E --> F[Detail 3]
      F --> G[Subdetail 1]
      E --> H[Detail 4]
      A --> I[Subtopic 3]
    
    """
    ) % text
    response = model.generate_content(prompt_mind_map)
    generated_structure = response.candidates[0].content.parts[0].text
    return generated_structure

def text_to_mind_map(text):
    lines = text.split('\n')
    mind_map = ""
    stack = []
    
    for line in lines:
        indent_level = len(re.match(r'^\s*', line).group())
        stripped_line = line.strip()
        
        if stripped_line:
            while stack and stack[-1][1] >= indent_level:
                stack.pop()
                
            node_id = f"id{len(stack)}_{indent_level}"
            
            if stack:
                mind_map += f"{stack[-1][0]} --> {node_id}[{stripped_line}]\n"
            else:
                mind_map += f"{node_id}[{stripped_line}]\n"
            
            stack.append((node_id, indent_level))
    
    return mind_map

# @app.route('/generate-mind-map', methods=['POST'])
# def generate_mind_map():
#     data = request.json
#     text = data.get('text')
#     api_key = data.get('api_key')
#     api_key = os.getenv('GOOGLE_API_KEY') 
#     configure_genai(api_key)
#     generated_structure = generate_mind_map_structure(text)
#     print(generated_structure)
#     mind_map_code = generated_structure
#     mind_map_code = mind_map_code.replace("```","")
#     print(mind_map_code)
    
#     return jsonify({"mind_map_code": mind_map_code})

# if __name__ == "__main__":
#     app.run(debug=True, port=8000,host='0.0.0.0')
