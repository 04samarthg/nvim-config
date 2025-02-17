// Import necessary modules
import express from "express";
import bodyParser from "body-parser";
import fs from "fs";

// Initialize express app and define port
const app = express();
const PORT = 10043;

// Array to store test cases
let testCases = [];

// Use body-parser middleware
app.use(bodyParser.json());

// Function to write a test case to a file
const writeTestCase = (testCase) => {
    const str = `${testCase.input}\nExpected Output:\n${testCase.output}`
    fs.writeFileSync('/home/pheonix/cp/ipf.in', str, (err) => {
        if (err) console.log(`Error writing input file: ${err}`);
    });
};

// Define a POST endpoint to receive and process test cases
app.post('/', (req, res) => {
    const data = req.body;
    // Map the received test cases to include an ID
    testCases = data.tests.map((test, index) => ({
        id: index + 1,
        input: test.input,
        output: test.output
    }));

    // Write the first test case to the file
    if (testCases.length > 0) {
        writeTestCase(testCases[0]);
    }

    // Send a 200 OK response
    res.sendStatus(200);
});

// Define a GET endpoint to retrieve all test cases
app.get('/testcases', (req, res) => {
    res.json(testCases);
});

// Start the server 
app.listen(PORT);
