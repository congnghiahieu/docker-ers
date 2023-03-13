# Evomaster
echo "Start Evomaster"
cd /home/Evomaster
java -jar /home/Evomaster/evomaster.jar --problemType REST --blackBox true --outputFormat $E_OUTPUT_FORMAT --maxTime $E_MAX_TIME --ratePerMinute $E_RATE_PER_MINUTE --outputFolder /home/result/Evomaster --bbSwaggerUrl $API_SPEC_URL > log.txt
cp /home/Evomaster/log.txt /home/result/Evomaster
echo "Finish Evomaster"