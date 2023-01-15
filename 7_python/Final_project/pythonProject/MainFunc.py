import csv
import os
import re
import boto3
import pathlib
import pandas as pd
from datetime import date
from os import path


'''
This Function to allow the user choose option where:
    (1)to enter new record      (2) to update a file rcord  (3) to delete record    (4) to view a file
    (5) to make a backup and upload it to aws   (6)  quit from the project
'''
def Menu():
    options = input(
        "Hello, please choose:\n1: Create Records \t2: update \t3: delete\n4: view File \t5: aws backup\t6: quit\n")
    if options == '1':
        EnterRecord()
    elif options == '2':
        update()
    elif options == '3':
        delete()
    elif options == '4':
        view_file()
    elif options == '5':
        aws_backup()
    elif options == '6':
        print("Goodbye")
        return 1
    else:
        print("please enter on of the options ")
    print("*" * 20)
    Menu()


# This function to input the record and sure the input is in valid form
def EnterRecord():
    # Name
    name = input("Please enter the Name: \n")
    # check that the name not containing any symbols, numbers only letters
    while not re.fullmatch("[A-Za-z]+[ [A-Za-z]+]*", name):
        print("Make sure you only use letters in your name ")
        name = input("Please enter your first name again: \n")
    # Home Address
    address = input("Please enter the Home address: \n")
    # Email Address
    email_address = input("Please enter the email address: \n")
    while not re.match(r"\b[A-Za-z0-9._%+-]+\@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b", email_address):
        print("Make sure you enter your Email in right format ")
        email_address = input("Please enter your Email again: \n")
    # Phone number
    phone = str(input("Please enter the phone number: \n"))
    while not re.match(r"(\+02)* *01+[1,0,2,5][0-9]{8}$", phone):
        print("Make sure you enter your phone number in right format  ")
        phone = str(input("Please enter your phone number again: \n"))
    #  today date
    today = (date.today()).strftime("%d/%m/%Y")
    data = [name, address, email_address, phone, today]
    # save the record
    SaveRecord(data)


# This Function to allow the user to  choose file and update any record's information in it by using its name
def update():
    SelectedFile = input("please enter the file name you want to edit\n")
    if not path.exists(SelectedFile):
        print("the file is not exist, try again")
        return 1
    df = pd.read_csv(SelectedFile)
    name = input("please enter the name you want to edit its information?\n")
    rowindex = ''
    for idx, row in df.iterrows():
        if row['Name'] == name:
            rowindex = idx
            print(rowindex)
    if rowindex == '':
        print("there is no one name like that")
        return 1
    # updating the column value/data
    edit_part = input("which info you want to change?\n1:name\n2:address\n3:email address\n4:phone\n")
    if edit_part == '1':
        name = input("please, Enter the new name")
        df.iloc[rowindex, 0] = name
        # writing into the file the new name
        df.to_csv(SelectedFile, index=False)
    elif edit_part == '2':
        address = input("please, Enter the new address\n")
        df.iloc[rowindex, 1] = address
        df.to_csv(SelectedFile, index=False)
    elif edit_part == '3':
        email = input("please, Enter the new email address\n")
        df.iloc[rowindex, 2] = email
        df.to_csv(SelectedFile, index=False)
    elif edit_part == '4':
        phone = input("please, Enter the new phone\n")
        df.iloc[rowindex, 3] = phone
        df.to_csv(SelectedFile, index=False)
    print("The file is updated")


# This Function to allow the user to  choose file and delete any record in it by using its name
def delete():
    SelectedFile = input("please enter the file name you want to delete from \n")
    # check the file is exist or not
    if not path.exists(SelectedFile):
        print("the file is not exist, try again")
        return 1
    df = pd.read_csv(SelectedFile)
    name = input("please enter the name you want to delete it ?\n")
    for idx, row in df.iterrows():
        if row['Name'] == name:
            rowindex = idx
            df = df.drop(df.index[rowindex])
            print("successfully deleted")
            df.to_csv(SelectedFile, index=False)
            return 1
    print("Not founded")


# This Function to allow the user to  choose file to view its content
def view_file():
    SelectedFile = input("please enter the file name to view \n")
    if not path.exists(SelectedFile):
        print("the file is not exist, try again")
        return 1
    with open(SelectedFile, 'r') as file:
        csvreader = csv.reader(file)
        for row in csvreader:
            print(row)


# This Function copy all files in a folder and archive it ,then uploaded the archive file to s3 bucket
def aws_backup():
    # check if folder is exist
    if not path.exists("aws_backup"):
        os.system("mkdir aws_backup")
    # copy all csv files in it and then archive the folder
    os.system("copy  *.csv aws_backup")
    os.system("tar -cvzf  aws_backup_zip aws_backup")
    print("Welcome to aws")
    # Take the s3 bucket name iam credentials to allow uploading to s3
    access_Key = input("please insert your iam aws access key\n")
    secret_Key = input("please insert your iam aws secret key\n")
    bucket_name = input("please input the bucket name\n")
    s3 = boto3.client("s3", aws_access_key_id=access_Key, aws_secret_access_key=secret_Key)
    object_name = "aws_backup_zip"
    file_name = os.path.join(pathlib.Path(__file__).parent.resolve(), "aws_backup_zip")
    response = s3.upload_file(file_name, bucket_name, object_name)



# This Function create today file if not exist , append if exist then save the argument data in it
def SaveRecord(data):
    filename = str("contactbook_" + str((date.today()).strftime("%d-%m-%Y")) + ".csv")
    with open(filename, 'a+', newline='\n') as f:
        writer = csv.writer(f)
        # check if the file is empty so it write the headers
        if os.stat(filename).st_size == 0:
            writer.writerow(["Name", "Home address", "Email Address", "Phone Number", "Insertion Date"])
        # save the data in the file
        writer.writerow(data)
