const express = require('express');
const bodyParser = require('body-parser');
const { Octokit } = require('@octokit/rest');
const fs = require('fs');

const app = express();
const port = 3000;

app.use(bodyParser.json());

// GitHub personal access token
const githubToken = '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';

const octokit = new Octokit({
  auth: githubToken,
});

app.post('/push-to-github', async (req, res) => {
  try {
    const { content, repositoryOwner, repositoryName, branchName, filePath } = req.body;

    // Create or update a file in a GitHub repository using the GitHub API
    const response = await octokit.repos.createOrUpdateFileContents({
      owner: repositoryOwner,
      repo: repositoryName,
      path: filePath,
      message: 'Add file',
      content: Buffer.from(content).toString('base64'), // Encode content in base64
      branch: branchName,
    });

    res.status(200).json(response.data);
  } catch (error) {
    console.error(error);
    res.status(500).send('GitHub에 파일을 업로드하는 중에 오류가 발생했습니다.');
  }
});

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
