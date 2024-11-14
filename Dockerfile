# Partiamo dall'immagine di base di DiffBind
FROM ghcr.io/giampaolomart/diffbind:main

# Setta le variabili di ambiente per evitare richieste interattive
ENV DEBIAN_FRONTEND=noninteractive

# Installa le dipendenze di sistema necessarie
RUN apt-get update && \
    apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    libcairo2-dev \
    libxt-dev \
    libpng-dev \
    libjpeg-dev \
    libtiff-dev \
    libpq-dev \
    libfontconfig1-dev \
    git \
    patch && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Installa BiocManager per la gestione dei pacchetti Bioconductor
RUN R -e "install.packages('BiocManager')"

# Installa il pacchetto ChIPseeker da Bioconductor
RUN R -e "BiocManager::install('ChIPseeker')"

# Installa plotly per l'uso di orca
RUN R -e "install.packages('plotly')"

# Installa orca utilizzando il pacchetto orca (con pacchetto plotly)
RUN R -e "devtools::install_github('ropensci/plotly')"

# Installa pacchetti aggiuntivi richiesti, come 'orca' per la gestione delle immagini
RUN R -e "install.packages('orca')"

# Crea un utente per l'accesso a RStudio
RUN useradd -m -s /bin/bash rstudio_user && \
    echo "rstudio_user ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Assegna la proprietà della directory all'utente rstudio_user
RUN chown -R rstudio_user:rstudio_user /home/rstudio_user

# Espone la porta 8787 per l'accesso a RStudio Server
EXPOSE 8787

# Esegui RStudio come utente rstudio_user
USER rstudio_user

