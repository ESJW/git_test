const express = require('express');
const bodyParser = require('body-parser');
const app = express();
const port = 3000;

app.use(bodyParser.json());

app.post('/save-to-local', (req, res) => {
    try {
        const { content } = req.body;
        
        // 사용자가 입력한 내용을 로컬 파일로 저장합니다.
        const fs = require('fs');
        fs.writeFileSync('myFile.txt', content);

        res.status(200).send('파일을 로컬에 성공적으로 저장했습니다.');
    } catch (error) {
        console.error(error);
        res.status(500).send('파일을 로컬에 저장하는 중에 오류가 발생했습니다.');
    }
});

app.listen(port, () => {
    console.log(`서버가 http://localhost:${port}에서 실행 중입니다.`);
});
