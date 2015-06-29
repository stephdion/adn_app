#!/bin/bash
dropdb daoa82nuj8smbi
rake db:create
pg_restore -d daoa82nuj8smbi ../../dump/adn_app/2015-02_04_final.dump
rake db:migrate
