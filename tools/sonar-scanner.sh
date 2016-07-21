#! /bin/sh

# Install and run SonarQube on travis. 


# On Mac OSX, you don't want to run SonarQube but to exec the build command directly.
if [ ${TRAVIS_OS_NAME} != 'linux' ]  
then
  exec "$@"
fi
# Passed this point, we are on Linux (exec never returns)


# Install required software
installSonarQubeScanner() {
  export SONAR_SCANNER_HOME=$HOME/.sonar/sonar-scanner-2.6
  rm -rf $SONAR_SCANNER_HOME
  mkdir -p $SONAR_SCANNER_HOME
  curl -sSLo $HOME/.sonar/sonar-scanner.zip http://repo1.maven.org/maven2/org/sonarsource/scanner/cli/sonar-scanner-cli/2.6/sonar-scanner-cli-2.6.zip
  unzip $HOME/.sonar/sonar-scanner.zip -d $HOME/.sonar/
  rm $HOME/.sonar/sonar-scanner.zip
  export PATH=$SONAR_SCANNER_HOME/bin:$PATH
  export SONAR_SCANNER_OPTS="-server"
}


installSonarQubeScanner


# and finally execute the actual SonarQube analysis (the SONAR_TOKEN is set from the travis web interface, to not expose it)
sonar-scanner -Dsonar.host.url=http://dev-sq.devops.aetnd.com -Dsonar.login=$SONAR_TOKEN
