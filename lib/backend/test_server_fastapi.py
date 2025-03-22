from fastapi import FastAPI, HTTPException, UploadFile, File, Form
from fastapi.responses import FileResponse
from pydantic import BaseModel
import os
import shutil;
import sqlite3 #Just for the early prototype and no encryption has been used

class UserModel(BaseModel):
    email : str
    password: str


app = FastAPI()

UPLOAD_DIR = 'static'

userConn = sqlite3.connect("UserDatabase.db", check_same_thread=False)
userCursor = userConn.cursor()

fileConn = sqlite3.connect("FileDatabase.db", check_same_thread=False)
fileCursor = fileConn.cursor()

users = userCursor.execute("SELECT * FROM Users").fetchall()
emails, passwords = zip(*users)
emails = list(emails)
passwords = list(passwords)

def refreshDatabase():
    global users, emails, passwords
    users = userCursor.execute("SELECT * FROM Users").fetchall()
    emails, passwords = zip(*users)
    emails = list(emails)
    passwords = list(passwords)

@app.get('/notes')
def get_all_notes_details():
    res = fileCursor.execute("Select * from Files;")
    result_dict = {}
    for i in res:
        subject = i[1]
        if subject not in result_dict:
            result_dict[subject] = []

        result_dict[subject].append({
            "id": i[0],
            "subject": subject,
            "name": i[2],
            "author": i[3],
            "desc": i[4]
        })
    return result_dict

@app.post('/login')
def login(req : UserModel):
    refreshDatabase()
    if req.email in emails:
        index = emails.index(req.email)
        if req.password == passwords[index]:
            return {"message": "success"}
        else:
            raise HTTPException(500, "Invalid Password")
    else:
        raise HTTPException(500, "No User Exists")

@app.post('/register')
def register(req: UserModel):
    userCursor.execute("INSERT INTO Users(email, password) VALUES(?,?)",(req.email, req.password))
    userConn.commit()
    return {"message": "success"}

@app.get('/view-pdf/{fileTag}')
def view_pdf(fileTag: str):
    print(fileTag)
    filePath = os.path.join('static', f"{fileTag}.pdf")
    if not os.path.exists(filePath):
        raise HTTPException(500, "No File Exists")
    return FileResponse(filePath)

@app.post('/upload')
def uploadFile(file: UploadFile = File(...), subject:str = Form(...), name:str = Form(...), author:str = Form(...), desc:str = Form(...)):
    filename = fileCursor.execute("SELECT id FROM Files ORDER BY id DESC LIMIT 1").fetchone()[0]
    path = os.path.join(UPLOAD_DIR, str(filename + 1)+".pdf")
    with open(path, 'wb') as buffer:
        shutil.copyfileobj(file.file, buffer)
    fileCursor.execute("INSERT INTO Files(subject, Name, Author, Desc) VALUES(?,?,?,?)",
( subject, name, author, desc))
    print(f"RECIECVED: {name}, {author}, {subject}, {desc}")
    fileConn.commit()
    return {'message': 'File uploaded Successfully'}