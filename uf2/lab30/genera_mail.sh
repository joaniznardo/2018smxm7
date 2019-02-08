echo -e "From: <>" | tee email.txt
echo -e "To: <>" | tee -a email.txt
echo -e "Subject: " | tee -a email.txt
echo -e "Date: `date -R`" | tee -a email.txt
echo -e "\nEl missatge és aquest" | tee -a email.txt
