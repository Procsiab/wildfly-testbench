# Install tools
sudo dnf install -y unzip wget java

# Download and extract WildFly
pushd /vagrant
if [ ! -d wildfly ]; then
    wget "https://download.jboss.org/wildfly/18.0.1.Final/wildfly-18.0.1.Final.zip" \
        -O wildfly.zip
    unzip wildfly.zip
    mv "wildfly-18.0.1.Final" "wildfly"
fi
popd

# Go to target build and copy it to the default EAP destination
pushd /vagrant/wildfly
JBOSS_HOME="/opt/wildfly-as-18"
sudo mkdir -p $JBOSS_HOME
sudo cp -ra * $JBOSS_HOME/
popd

# Create jboss user and set permission on installation
pushd $JBOSS_HOME
sudo useradd -r jboss
sudo chown -R jboss:jboss .
popd

# Add JBOSS home directory to PATH variable
cat << EOF >> ~/.bashrc
JBOSS_HOME=/opt/wildfly-as-18
PATH=$PATH:$JBOSS_HOME/bin
export JBOSS_HOME PATH
EOF
source ~/.bashrc

# Start the server by going to $JBOSS_HOME/bin and running
# sudo -u jboss ./standalone.sh -bmanagement 0.0.0.0 -b=0.0.0.0
