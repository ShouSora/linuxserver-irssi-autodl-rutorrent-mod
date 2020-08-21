## Buildstage ##
FROM lsiobase/alpine:3.12 as buildstage

RUN \
 echo "**** install packages/ temp directory ****" && \
 apk add --no-cache \
	curl \
	wget \
	git && \
 mkdir -p /root-layer/autodl-irssi && \
 cd /root-layer
	
RUN \
 echo "**** download autodl-irssi rutorrent plugin ****" && \
 git clone https://github.com/autodl-community/autodl-rutorrent.git autodl-irssi-plugin --quiet && \
 if [ -f /root-layer/autodl-irssi/conf.php ]; then \
	rm /root-layer/autodl-irssi/conf.php; fi
	
RUN \
  echo "**** download autodl-irssi ****" && \
  cd /root-layer/autodl-irssi && \
  downloadurl=`curl -sL --retry-connrefused http://git.io/vlcND | sed 's/.*"browser_download_url"[".: ]*\([^}]*}\).*/\1/; s/\(.*zip\).*/\1/'` && \
  echo "**** downloading from ${downloadurl}" && \
  echo $downloadurl | xargs wget -q -O autodl-irssi.zip && \
  unzip -o autodl-irssi.zip && \
  rm autodl-irssi.zip
  


  
## Single layer deployed image ##
FROM scratch

# Add files from buildstage
COPY --from=buildstage /root-layer/ /