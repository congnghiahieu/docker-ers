# Schemathesis
echo "Start Schemathesis"
cd /home/schemathesis
st run --verbosity --workers $S_WORKER --checks $S_CHECKS --cassette-path=all.yaml --hypothesis-max-examples=$S_TESTCASE_PER_OPERATION --stateful=links --base-url $S_BASE_URL $API_SPEC_URL > log.txt
st replay all.yaml --status=FAILURE > fail.txt
mkdir /home/result/Schemathesis
cp /home/schemathesis/log.txt /home/result/Schemathesis
cp /home/schemathesis/all.yaml /home/result/Schemathesis
cp /home/schemathesis/fail.txt /home/result/Schemathesis
echo "Finish Schemathesis"