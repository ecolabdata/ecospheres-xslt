## Description

Sépare les conditions d'utilisation des conditions d'accès.


## Paramètres

Aucun.


## Motivation

Lorsqu'un élément `gmd:resourceConstraints` contient à la fois un élément `gmd:accessConstraints` et un élément `gmd:useConstraints`, tous les éléments `gmd:otherConstraints` également présents vont être doublonnés en condition d'utilisation *et* en condition d'accès par le convertisseur SEMICeu ISO-19139 vers GeoDCAT-AP.

Un tel cas ne respectant pas le standard INSPIRE, il est difficile motiver une évolution du convertisseur SEMICeu.


## Limitations

La transformation prend en charge uniquement les cas pour lesquels la séparation des conditions d'utilisation et d'accès : 

- améliore la prise en charge des métadonnées par data.gouv.fr ;
- n'est pas ambigue, ou peut être désambiguïsée de manière relativement fiable ;
- n'affecte pas significativement l'interprétation de cette section dans le catalogue d'origine.

Les autres cas pourront faire l'objet de futures améliorations, ou devront être traités manuellement.

La mise en conformité générale avec le standard INSPIRE ne fait pas partie des objectifs.


## Exemples

TODO


## Références

[https://ecospheres.gitbook.io/recommandations-iso-dcat/adaptation-des-metadonnees-iso-19139-pour-faciliter-la-transformation-en-dcat/separer-la-licence-des-conditions-dacces](https://ecospheres.gitbook.io/recommandations-iso-dcat/adaptation-des-metadonnees-iso-19139-pour-faciliter-la-transformation-en-dcat/separer-la-licence-des-conditions-dacces)
