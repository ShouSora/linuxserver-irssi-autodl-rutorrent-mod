## Buildstage ##
FROM lsiobase/alpine:3.12 as buildstage

ARG github_token

RUN \
 echo "**** install packages/ temp directory ****" && \
 apk add --no-cache \
	curl \
	wget \
	git && \
 mkdir -p /root-layer/autodl-irssi
	
RUN \
 echo "**** download autodl-irssi rutorrent plugin ****" && \
 git clone https://github.com/autodl-community/autodl-rutorrent.git /root-layer/autodl-irssi-plugin --quiet && \
 if [ -f /root-layer/autodl-irssi-plugin/conf.php ]; then \
	rm /root-layer/autodl-irssi-plugin/conf.php; fi
	
RUN \
  echo "**** download autodl-irssi ****" && \
  cd /root-layer/autodl-irssi && \
  downloadurl=`curl -sL --retry-connrefused http://git.io/vlcND?access_token=$github_token | tr '\n' ' ' | sed 's/.*"browser_download_url"[".: ]*\([^}]*}\).*/\1/; s/\(.*zip\).*/\1/'` && \
  echo "**** downloading from ${downloadurl}" && \
  echo $downloadurl | xargs wget -q -O autodl-irssi.zip && \
  unzip -o autodl-irssi.zip && \
  rm autodl-irssi.zip
  

# Copy local files from dockermod
COPY root/ /root-layer/

  
## Single layer deployed image ##
FROM scratch

# Add files from buildstage
COPY --from=buildstage /root-layer/ /