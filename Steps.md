# Step-by-Step Workflow

## 1. Hello, World! Actions

* Actions Marketplace Documenting file - `action.yml`

```yml
name: 'Hello, World Test Action'
description: 'Learning GitHub Actions'
author: 'Nishkarsh Raj'
inputs:
  src:
    description: 'None Required'
runs:
  using: 'docker'
  image: 'Dockerfile'
branding:
  icon: 'check-circle'
  color: 'green'
```

## 2. Maintainer's Corner

## 3. CI/CD

* Apache Maven Build CI

```yml
name: Java CI with Maven

on:
  pull_request:
    branches: [ main ]

jobs:
  build:

    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v2
    - name: Set up JDK 11
      uses: actions/setup-java@v2
      with:
        java-version: '11'
        distribution: 'adopt'
    - name: Build with Maven
      run: mvn clean install
```

* Apache Maven GitHub Packages

```xml
<distributionManagement>
		<repository>
		  <id>mvn-repo</id>
		  <name>NishkarshRaj</name>
		  <url>https://maven.pkg.github.com/NishkarshRaj/Awesome-GitHub-Actions</url>
		</repository>
</distributionManagement>
```

```yml
name: Maven Package

on:
  release:
    types: [created]

jobs:
  build:

    runs-on: ubuntu-latest
    permissions:
      contents: read
      packages: write

    steps:
    - uses: actions/checkout@v2
    - name: Set up JDK 11
      uses: actions/setup-java@v2
      with:
        java-version: '11'
        distribution: 'adopt'
        server-id: mvn-repo
        settings-path: ${{ github.workspace }} # location for the settings.xml file

    - name: Build with Maven
      run: mvn clean install

    - name: Publish to GitHub Packages Apache Maven
      run: mvn deploy -s $GITHUB_WORKSPACE/settings.xml
      env:
        GITHUB_TOKEN: ${{ github.token }}
```

* Docker Push

```yml
name: DockerHub CI
on:
  push
  
jobs:
  push:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      
      - name: Set up JDK 11
        uses: actions/setup-java@v2
        with:
          java-version: '11'
          distribution: 'adopt'
      
      - name: Build with Maven
        run: mvn clean install

      - name: Create Docker Image for Development Environment
        run: docker build -t nishkarshraj/awesome-github-action .

      - name: Login to DockerHub
        uses: docker/login-action@v1 
        with:
          username: ${{ secrets.username }}
          password: ${{ secrets.password }}
        
      - name: Docker Push
        run: docker push nishkarshraj/awesome-github-action
```

* Dependabot

```yml
version: 2
updates:
  # Enable version updates for Maven
  - package-ecosystem: "maven"
    directory: "/"
    schedule:
      interval: "daily"
```

## 4. Notification Center

```yml
name: Discord Messenger

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

  workflow_dispatch:

jobs:
  build:
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v2

      - name: send message
        uses: appleboy/discord-action@master
        with:
          webhook_id: ${{ secrets.WEBHOOK_ID }}
          webhook_token: ${{ secrets.WEBHOOK_TOKEN }}
          color: "#48f442"
          username: "NoiceCurse"
          message: The ${{ github.event_name }} event triggered this message from GitHub
```

```yml
name: Slack Chat Messender
 
on:
  # Triggers the workflow on push or pull request events but only for the main branch
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

  # Allows you to run this workflow manually from the Actions tab
  workflow_dispatch:

# A workflow run is made up of one or more jobs that can run sequentially or in parallel
jobs:
  # This workflow contains a single job called "build"
  build:
    # The type of runner that the job will run on
    runs-on: ubuntu-latest

    # Steps represent a sequence of tasks that will be executed as part of the job
    steps:
     - name: Notify slack
       env:
         SLACK_BOT_TOKEN: ${{ secrets.SLACK_BOT_TOKEN }}
       uses: pullreminders/slack-action@master
       with:
         args: '{\"channel\":\"general\",\"text\":\"Hi, This is Test Bot\"}'
```

## 5. Miscellaneous Corner

```yml
name: Metrics
on:
  # Schedule updates (each hour)
  schedule: [{ cron: "0 * * * *" }]
  # Lines below let you run workflow manually and on each commit
  workflow_dispatch:
  push: { branches: ["master", "main"] }
jobs:
  github-metrics:
    runs-on: ubuntu-latest
    steps:
      - uses: lowlighter/metrics@latest
        with:
          # Your GitHub token
          token: ${{ secrets.GH_TOKEN }}

          # Options
          user: nishkarshraj
          template: classic
          base: header, activity, community, repositories
          config_timezone: America/New_York

          plugin_achievements: yes
          plugin_achievements_secrets: yes
          plugin_achievements_threshold: C
          plugin_achievements_limit: 6
```
