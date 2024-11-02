## Description

Convertit une licence, condition d'utilisation ou condition d'usage formulée en texte libre en sa balise équivalente.


## Paramètres

Aucun.


## Limitations

La détection d'une balise se base sur une comparaison du texte libre d'origine avec un dictionnaire.
Les entrées du dictionnaire sont volontairement limitées de manière à éviter les faux positifs.
En conséquence, toute divergence avec la traduction CNIG des mentions standard INSPIRE fera échouer la détection.

La transformation ne s'applique qu'aux éléments `gmd:otherConstraints`.
Les éléments `gmd:useLimitation` ne sont pas pris en charge car ils ne doivent pas servir à représenter les informations traitées ici.


## Exemples

TODO


## Références

[https://ecospheres.gitbook.io/recommandations-iso-dcat/adaptation-des-metadonnees-iso-19139-pour-faciliter-la-transformation-en-dcat/faciliter-la-reconnaissance-des-licences](https://ecospheres.gitbook.io/recommandations-iso-dcat/adaptation-des-metadonnees-iso-19139-pour-faciliter-la-transformation-en-dcat/faciliter-la-reconnaissance-des-licences)
