## Description

Sépare les conditions d'utilisation des conditions d'accès.


## Paramètres

Aucun.


## Prérequis

- <a href="constraints-convert-to-anchor">`constraints-convert-to-anchor`</a> (recommandé).


## Motivation

Lorsqu'un élément `gmd:resourceConstraints` contient à la fois un élément `gmd:accessConstraints` et un élément `gmd:useConstraints`, tous les éléments `gmd:otherConstraints` également présents vont être doublonnés en condition d'utilisation *et* en condition d'accès par le convertisseur SEMICeu ISO-19139 vers GeoDCAT-AP.

Un tel cas ne respectant pas le standard INSPIRE, il est difficile motiver une évolution du convertisseur SEMICeu.


## Limites

La transformation prend en charge uniquement les cas pour lesquels la séparation des conditions d'utilisation et d'accès :
- Améliore la prise en charge des métadonnées par data.gouv.fr ;
- N'est pas ambigue, ou peut être désambiguïsée de manière relativement fiable ;
- N'affecte pas significativement l'interprétation de cette section dans le catalogue d'origine.

Les autres cas pourront faire l'objet de futures améliorations, ou devront être traités manuellement.

La mise en conformité générale avec le standard INSPIRE ne fait pas partie des objectifs.


## Exemples

```
<gmd:resourceConstraints>
  <gmd:MD_LegalConstraints>
    <gmd:useLimitation>
       <gco:CharacterString>Licence Ouverte / Open Licence Version 2.0  https://www.etalab.gouv.fr/wp-content/uploads/2017/04/ETALAB-Licence-Ouverte-v2.0.pdf</gco:CharacterString>
    </gmd:useLimitation>
    <gmd:useLimitation>
      <gco:CharacterString>Aucun des articles de la loi ne peut être invoqué pour justifier d'une restriction d'accès public.</gco:CharacterString>
    </gmd:useLimitation>
    <gmd:accessConstraints>
      <gmd:MD_RestrictionCode codeListValue="otherRestrictions" codeList="http://standards.iso.org/iso/19139/resources/gmxCodelists.xml#MD_RestrictionCode"/>
    </gmd:accessConstraints>
    <gmd:useConstraints>
      <gmd:MD_RestrictionCode codeListValue="license" codeList="http://standards.iso.org/iso/19139/resources/gmxCodelists.xml#MD_RestrictionCode"/>
    </gmd:useConstraints>
    <gmd:otherConstraints>
      <gco:CharacterString>Pas de restriction d'accès public selon INSPIRE</gco:CharacterString>
    </gmd:otherConstraints>
  </gmd:MD_LegalConstraints>
</gmd:resourceConstraints>
```

devient :

```
<gmd:resourceConstraints>
  <gmd:MD_LegalConstraints>
    <gmd:accessConstraints>
      <gmd:MD_RestrictionCode codeListValue="otherRestrictions" codeList="http://standards.iso.org/iso/19139/resources/gmxCodelists.xml#MD_RestrictionCode"/>
    </gmd:accessConstraints>
    <gmd:otherConstraints>
      <gco:CharacterString>Pas de restriction d'accès public selon INSPIRE</gco:CharacterString>
    </gmd:otherConstraints>
  </gmd:MD_LegalConstraints>
</gmd:resourceConstraints>
<gmd:resourceConstraints>
  <gmd:MD_LegalConstraints>
    <gmd:useLimitation>
      <gco:CharacterString>Licence Ouverte / Open Licence Version 2.0  https://www.etalab.gouv.fr/wp-content/uploads/2017/04/ETALAB-Licence-Ouverte-v2.0.pdf</gco:CharacterString>
    </gmd:useLimitation>
    <gmd:useLimitation>
      <gco:CharacterString>Aucun des articles de la loi ne peut être invoqué pour justifier d'une restriction d'accès public.</gco:CharacterString>
    </gmd:useLimitation>
    <gmd:useConstraints>
      <gmd:MD_RestrictionCode codeListValue="license" codeList="http://standards.iso.org/iso/19139/resources/gmxCodelists.xml#MD_RestrictionCode"/>
    </gmd:useConstraints>
  </gmd:MD_LegalConstraints>
</gmd:resourceConstraints>
```


## Messages

Les messages suivants peuvent être affichés lors qu'un cas ambigu (mélangeant contraintes d'accès et d'utilisation) est traité : 


> 'otherConstraints' -> 'accessConstraints', car 'Anchor'="LimitationsOnPublicAccess".

Si un élément `gmd:MD_LegalConstraints` :
- Contient un `gmd:otherConstraints` dont le `gmd:Anchor` fait référence au vocabulaire INSPIRE [LimitationsOnPublicAccess](https://inspire.ec.europa.eu/metadata-codelist/LimitationsOnPublicAccess/) ;
- Contient un `gmd:useConstraints`.

Alors l'élément `gmd:otherConstraints` est considéré comme une contrainte d'accès, et réaffecté à un `gmd:MD_LegalConstraints` contenant un `gmd:accessConstraints`.


> 'otherConstraints' -> 'accessConstraints', car présence de 'useLimitation'.

Si un élément `gmd:MD_LegalConstraints` :
- Contient un `gmd:otherConstraints` ;
- Contient un `gmd:accessConstraints` et un `gmd:useConstraints` dont les attributs `codeListValue` ne permettent pas de rattacher sans ambiguité le `gmd:otherConstraints` ;
- Contient un ou plusieurs éléments `gmd:useLimitation`.

Alors l'élément `gmd:otherConstraints` est considéré comme une contrainte d'accès, et réaffecté à un `gmd:MD_LegalConstraints` contenant un `gmd:accessConstraints`.

Cette interprétation repose uniquement sur l'observation de cas existants.
Il est donc conseillé de vérifier ces cas.


> 'otherConstraints' -> 'useConstraints', mais souvent problématique.

Si un élément `gmd:MD_LegalConstraints` :
- Contient un `gmd:otherConstraints` ;
- Contient un `gmd:accessConstraints` dont l'attribut `codeListValue` est différent de "otherRestrictions" ;
- Contient un `gmd:useConstraints` dont l'attribut est égal à "otherRestrictions".

Alors l'élément `gmd:otherConstraints` est considéré comme une condition d'utilisation et reste affecté au `gmd:MD_LegalConstraints` contenant le `gmd:useConstraints`.

Cette interprétation est conforme à la spécification mais souvent incorrecte en pratique.
Il est donc conseillé de vérifier ces cas.


> 'otherConstraints' ambigu.

Si un élément `gmd:MD_LegalConstraints` :
- Contient un `gmd:otherConstraints` ;
- Contient un `gmd:accessConstraints` ;
- Contient un `gmd:useConstraints` ;
- Reste ambigu malgré la prise en charge des autres cas ci-dessus.

Alors l'élément `gmd:otherConstraints` est considéré comme ne pouvant pas être traité automatiquement.

De tels cas doivent donc être corrigés manuellement.
Cependant, s'il vous semble qu'un cas pourrait être mieux pris en charge, merci de nous le signaler à ecospheres@developpement-durable.gouv.fr.


## Références

https://github.com/ecolabdata/ecospheres/wiki/Recommandations-ISO-DCAT#s%C3%A9parer-la-licence-des-conditions-dacc%C3%A8s
