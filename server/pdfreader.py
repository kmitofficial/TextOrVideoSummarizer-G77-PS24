from PyPDF2 import PdfReader
def read_pdf(file_path):
    reader = PdfReader(file_path)
    number_of_pages = len(reader.pages)
    string1 = ""
    for i in range(number_of_pages):
        page = reader.pages[i]
        text = page.extract_text()
        string1 += text
    return string1
