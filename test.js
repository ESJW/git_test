const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const fs = require('fs');
const app = express();
const port = 3000;

app.use(bodyParser.json());
app.use(cors());
app.post('/save-to-server', (req, res) => {
    try {
        const { content } = req.body;

        if (!content) {
            return res.status(400).send('데이터가 비어 있습니다.');
        }

        // 파일로 저장
        fs.writeFile('savedFile.txt', content, (err) => {
            if (err) {
                console.error(err);
                res.status(500).json('파일을 저장하는 중에 오류가 발생했습니다.');
            } else {
                console.log('파일이 성공적으로 저장되었습니다.');
                res.status(200).json({ message: '파일이 성공적으로 저장되었습니다.' });
            }
        });
    } catch (error) {
        console.error(error);
        res.status(500).json('파일을 저장하는 중에 오류가 발생했습니다.');
    }
});

app.listen(port, () => {
    console.log(`서버가 http://localhost:${port}에서 실행 중입니다.`);
});