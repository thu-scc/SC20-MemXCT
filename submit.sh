#!/bin/bash
mkdir -p submission
rm artifact.zip
zip -r artifact.zip ReproducibilityChallenge
cp artifact.zip submission/
cp ReproducibilityChallenge/doc/*.pdf submission
