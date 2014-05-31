@echo off
REM This batch file will be run from the same directory as the file that you need to PGP.
SETLOCAL

REM TODO - validate return codes. 
REM TODO - dynamic client and carrier
REM TODO - more dynamic filenames
REM TODO - run from any directory
REM TODO - better comments. And actually DO the TODOs.

REM Set default variables.
SET defaultSourceKey=0xA123456A
SET defaultDestinationKey=0xA654321A

SET theClient="Client Name"
SET theCarrierCode="Carrier_Coverage"

SET currentFileName="testFile_DATE.txt"
SET finalFileName="testfile.txt"
SET pgpFileName="testfile.txt.pgp"

REM Initial Run through and retry for file name.
:tryAgain
CLS

REM Reset filename to default
SET filename=
REM Prompt for the file name to PGP.
SET /p filename=Please enter the File Name to PGP: 
REM Check to see if the file exists in the current directory.
IF EXIST "%filename%" (
	REM If the file exists, pgp it.
	GOTO :checkPgpKey
) ELSE (
	REM If the file doesn't exist, do you want to retry?
	ECHO Oops. The file that you wanted to encrypt doesn't exist. Is this batch file in the same directory as the file you want to encrypt?
	GOTO :wantToTryAgain 
)

:checkPgpKey
REM Prompt to enter a PGP key if you don't want to use the defaultDestinationKey.
SET pgpKey=%defaultDestinationKey%
SET /p pgpKey=Please enter the PGP Key (Default is %theClient% - %theCarrierCode%): 

REM Check to see if entered key is a valid Hex key for PGP. 
SET /a pgpKeyVal="%pgpKey%"*1
IF "%pgpKeyVal%" == "0" ( 
	ECHO Please enter a valid hex encryption key.
	GOTO :checkPgpKey
) ELSE (
	GOTO :copyFileName
)

:copyFileName
ECHO Copying %filename% to %currentFileName%
SET exportFile=
COPY /Y %filename% %finalFileName%

SET exportFile=%finalFileName%

GOTO :runPGP

:runPGP
ECHO Beginning PGP process on %exportFile% with a key of %pgpKey%.

REM All was good. Call PGP.
x:\Automation\gpg\gpg --homedir "\\nas\files\Automation\gpg" --recipient %defaultSourceKey% --recipient %pgpKey% --output "%pgpFileName%" --yes --encrypt "%exportFile%"

ECHO PGP Complete.
GOTO :wantToSendToFTP

:wantToSendToFTP
SET /P qSendToFTPYN=Do you want to send to the %theCarrierCode% FTP (Y/N)? 
IF /i {%qSendToFTPYN%}=={y} (GOTO :sendToFTP) 
IF /i {%qSendToFTPYN%}=={yes} (GOTO :sendToFTP)
GOTO :encryptAnother 

:sendToFTP
REM We have to change the filename. We are deleting the last file and renaming the file we need to pgp and send.
ECHO Deleting Original Name. 
DEL %pgpFileName%
ECHO Renaming file for FTP send. 
REN %pgpFileName% %exportFile%
ECHO Sending file to FTP. 
x:\Automation\WinSCP\WinSCP.exe \WinSCP\winscp.com /ini=x:\Automation\WinSCP\WinSCP.ini /log=WinSCP_%theCarrierCode%.log /command "option batch abort" "option confirm off" "open ftp://user:password@carrier.ftp.com" "put %exportFile%" "exit"
ECHO File sent.
GOTO :encryptAnother 

:encryptAnother
SET /P qEncryptAnotherYN=Do you want to encrypt another file (Y/N)? 
IF /i {%qEncryptAnotherYN%}=={y} (GOTO :tryAgain) 
IF /i {%qEncryptAnotherYN%}=={yes} (GOTO :tryAgain) 
GOTO :bailOut 

:wantToTryAgain
SET /P qTryAgainYN=Do you want to try again (Y/N)? 
IF /i {%qTryAgainYN%}=={y} (GOTO :tryAgain) 
IF /i {%qTryAgainYN%}=={yes} (GOTO :tryAgain) 
GOTO :bailOut

:bailOut 
ECHO Goodbye.
REM EXIT /b 1
ENDLOCAL
TIMEOUT /t 10	
