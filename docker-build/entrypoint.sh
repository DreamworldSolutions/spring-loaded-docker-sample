#! /bin/bash
if [ -z $SPRINGLOADEDADAPTER_DISABLE ]; then
        SPRINGLOADEDADAPTER_DISABLE=false
fi

if [ $SPRINGLOADEDADAPTER_DISABLE = true ]; then
	 exec java -Xdebug -Xrunjdwp:server=y,transport=dt_socket,suspend=n -Djava.security.egd=file:/dev/./urandom $JAVA_OPTS -cp /app/ org.springframework.boot.loader.JarLauncher
else
	 exec java -Djava.security.egd=file:/dev/./urandom $JAVA_OPTS -cp /app/ -javaagent:/springloaded-1.2.5.RELEASE.jar -noverify org.springframework.boot.loader.JarLauncher	
fi