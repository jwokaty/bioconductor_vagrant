# Needed for rjags

{% set machine = salt["pillar.get"]("machine") %}
{% set download = machine.dependencies.jags.split("/")[-1] %}
{% set jags = download[:-4] %}

download_jags:
  cmd.run:
    - name: curl -LO {{ machine.dependencies.jags }}
    - cwd:  {{ machine.user.home }}/biocbuild/Downloads
    - user: biocbuild

install_jags:
  cmd.run:
    - name: installer -pkg {{ machine.user.home }}/biocbuild/Downloads/{{ jags }}.pkg -target /
    - require:
      - cmd: download_jags

fix_/usr/local_permissions_jags:
  cmd.run:
    - name: |
        chown -R biocbuild:admin /usr/local/*
        chown -R root:wheel /usr/local/texlive
    - require:
      - cmd: install_jags

test_rjags_install:
  cmd.run:
    - name: Rscript -e 'install.packages("rjags", type="source", repos="https://cran.r-project.org")'
    - runas: biocbuild
