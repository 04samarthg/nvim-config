import express from "express";
import bodyParser from "body-parser";
import fs from "fs";

const app = express();
const PORT = 10043;

let testCases = [];

app.use(bodyParser.json());

const writeTestCase = (testCase) => {
    const str = `${testCase.input}\nExpected Output:\n${testCase.output}`
    fs.writeFileSync('/home/pheonix/cp/ipf.in', str, (err) => {
        if (err) console.log(`Error writing input file: ${err}`);
    });
};

app.post('/', (req, res) => {
    const data = req.body;
    testCases = data.tests.map((test, index) => ({
        id: index + 1,
        input: test.input,
        output: test.output
    }));
    
    if (testCases.length > 0) {
        writeTestCase(testCases[0]);
    }

    res.sendStatus(200);
});

app.get('/testcases', (req, res) => {
    res.json(testCases);
});

app.listen(PORT);
