FROM debian:11-slim as download
RUN apt-get update && apt-get upgrade -y && apt-get install -y curl
RUN curl -OL https://github.com/Illumina/ExpansionHunter/releases/download/v5.0.0/ExpansionHunter-v5.0.0-linux_x86_64.tar.gz
RUN curl -OL https://github.com/Illumina/RepeatCatalogs/archive/refs/tags/v1.0.0.tar.gz
RUN tar xzf ExpansionHunter-v5.0.0-linux_x86_64.tar.gz
RUN tar xzf v1.0.0.tar.gz
RUN gzip /RepeatCatalogs-1.0.0/hg38/variant_catalog.json
RUN gzip /RepeatCatalogs-1.0.0/hg19/variant_catalog.json

FROM debian:11-slim
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y zlib1g libbz2-1.0 liblzma5 libssl1.1 libcurl4 samtools bcftools tabix && \
    apt-get clean && rm -rf rm -rf /var/lib/apt/lists/*
RUN mkdir -p /opt/local && mkdir -p /opt/local/catalogs/hg38 && mkdir -p /opt/local/catalogs/hg19
COPY --from=download /ExpansionHunter-v5.0.0-linux_x86_64/ /opt/local
COPY --from=download /RepeatCatalogs-1.0.0/hg38/variant_catalog.json.gz /opt/local/catalogs/hg38/
COPY --from=download /RepeatCatalogs-1.0.0/hg19/variant_catalog.json.gz /opt/local/catalogs/hg19/
COPY Dockerfile /
ENV PATH=${PATH}:/opt/local/bin
