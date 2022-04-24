import sys
import os
from PIL import Image

def create_image(fileName,imNum):
    allLines=''
    theTag='.IMG'+format(imNum,'02d')
    curLine=theTag+'      DC.L    '
    theImage=Image.open(fileName).convert('RGB')


    for y in range(128):
        for x in range(128):
            r,g,b=theImage.getpixel((x,y))
            curValue=int(b)<<16|int(g)<<8|int(r)
            curString='$'+format(curValue,'08X')+','
            if (len(curLine)+len(curString))<80:
                curLine+=curString
            else:
                allLines+=(curLine[:-1]+'\n')
                curLine='            DC.L    '+curString
    allLines+=(curLine[:-1]+'\n')
    return allLines

def create_images(fileList,outPath):
    allLines="""
; -----------------------------------------------------------------------------
; IMGDATA CONTAINS THE CODED GAME OVER IMAGE. IS A SET OF 128X128 COLORS
; CORRESPONDING TO EVERY PIXEL COLOR OF THE COLUMNS AND ROWS OF THE IMAGE
; -----------------------------------------------------------------------------\n

"""[1:]
    curLine='IMGDATA     DC.L    '
    for imNum in range(len(fileList)):
        curString='.IMG'+format(imNum,'02d')+','
        if (len(curLine)+len(curString))<80:
            curLine+=curString
        else:
            allLines+=(curLine[:-1]+'\n')
            curLine='            DC.L    '+curString
    allLines+=(curLine[:-1]+'\n')
    for imNum in range(len(fileList)):
        allLines+=create_image(fileList[imNum],imNum)

    outFName=os.path.join(outPath,'IMGDATA.X68')
    with open(outFName,'w') as outFile:
        outFile.writelines(allLines)

create_images(['../RES/GameOver.png'],'../')