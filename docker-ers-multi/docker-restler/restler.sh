# Rester-Fuzzer
echo "Start Restler"
cd /home/Restler
mkdir /home/result/Restler
## Compile
echo "Start Compile"
wget -O $R_SPEC_FILE_NAME $API_SPEC_URL
/home/Restler/restler_bin/restler/Restler compile --api_spec $R_SPEC_FILE_NAME
cp $R_SPEC_FILE_NAME /home/result/Restler
cp -R Compile /home/result/Restler
echo "Finish Compile"
## Test
echo "Start Test"
/home/Restler/restler_bin/restler/Restler test --grammar_file Compile/grammar.py --dictionary_file Compile/dict.json --settings Compile/engine_settings.json --no_ssl > test-log.txt
cp /home/Restler/test-log.txt /home/result/Restler
cp -R /home/Restler/Test /home/result/Restler
echo "Finish Test"
## FuzzLean
echo "Start FuzzLean"
/home/Restler/restler_bin/restler/Restler fuzz-lean --grammar_file Compile/grammar.py --dictionary_file Compile/dict.json --settings Compile/engine_settings.json --no_ssl > fuzzlean-log.txt
cp /home/Restler/fuzzlean-log.txt /home/result/Restler
cp -R /home/Restler/FuzzLean /home/result/Restler
echo "Finish FuzzLean"
## Fuzz
echo "Start Fuzz"
/home/Restler/restler_bin/restler/Restler fuzz --grammar_file Compile/grammar.py --dictionary_file Compile/dict.json --settings Compile/engine_settings.json --no_ssl --time_budget $R_FUZZ_TIME_BUDGET > fuzz-log.txt
cp /home/Restler/fuzz-log.txt /home/result/Restler
cp -R /home/Restler/Fuzz /home/result/Restler
echo "Finish Fuzz"
echo "Finish Restler"
