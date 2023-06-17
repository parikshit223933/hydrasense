# Use a slim version of the OpenJDK image
FROM openjdk:11-jre-slim

# Set environment variables
ENV JAVA_HOME /usr/lib/jvm/java-11-openjdk-amd64
ENV JDTLS_HOME /jdtls

# Install wget and unzip
RUN apt-get update && apt-get install -y wget unzip

# Download and extract the Eclipse JDT Language Server
RUN mkdir -p $JDTLS_HOME && \
    wget -qO- http://download.eclipse.org/jdtls/snapshots/jdt-language-server-latest.tar.gz | tar xvz -C $JDTLS_HOME

# Expose the port the language server will run on
EXPOSE 8080

# Start the language server
CMD java -Declipse.application=org.eclipse.jdt.ls.core.id1 -Dosgi.bundles.defaultStartLevel=4 -Declipse.product=org.eclipse.jdt.ls.core.product -Dlog.level=ALL -noverify -Xmx1G -jar /jdtls/plugins/org.eclipse.equinox.launcher_*.jar -configuration /jdtls/config_linux -data /workspace --add-modules=ALL-SYSTEM --add-opens java.base/java.util=ALL-UNNAMED --add-opens java.base/java.lang=ALL-UNNAMED

