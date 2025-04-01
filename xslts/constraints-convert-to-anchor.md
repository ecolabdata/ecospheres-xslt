## Description

Convertit une licence, condition d'utilisation ou condition d'usage formulée en texte libre en sa balise équivalente.


## Paramètres

Aucun.


## Prérequis

Aucun.


## Limites

La détection d'une balise se base sur une comparaison du texte libre d'origine avec un dictionnaire.
Les entrées du dictionnaire sont volontairement limitées de manière à éviter les faux positifs.
En conséquence, toute divergence avec la traduction CNIG des mentions standard INSPIRE fera échouer la détection.

La transformation ne s'applique qu'aux éléments `gmd:otherConstraints`.
Les éléments `gmd:useLimitation` ne sont pas pris en charge car ils ne doivent pas servir à représenter les informations traitées ici.


## Exemples

```
<gmd:resourceConstraints>
  <gmd:MD_LegalConstraints>
    <gmd:otherConstraints>
      <gco:CharacterString>Licence Ouverte / Open Licence Version 2.0  https://www.etalab.gouv.fr/wp-content/uploads/2017/04/ETALAB-Licence-Ouverte-v2.0.pdf</gco:CharacterString>
    </gmd:otherConstraints>
  </gmd:MD_LegalConstraints
</gmd:resourceConstraints>
```

devient :

```
<gmd:resourceConstraints>
  <gmd:MD_LegalConstraints>
    <gmd:otherConstraints>
      <gmx:Anchor xlink:href="https://spdx.org/licenses/etalab-2.0">Licence Ouverte / Open Licence version 2.0</gmx:Anchor>
    </gmd:otherConstraints>
  </gmd:MD_LegalConstraints
</gmd:resourceConstraints>
```

<br/>

```
<gmd:resourceConstraints>
  <gmd:MD_LegalConstraints>
    <gmd:otherConstraints>
     <gco:CharacterString>Pas de restriction d’accès public selon INSPIRE</gco:CharacterString>
    </gmd:otherConstraints>
  </gmd:MD_LegalConstraints
</gmd:resourceConstraints>
```

devient :

```
<gmd:resourceConstraints>
  <gmd:MD_LegalConstraints>
    <gmd:otherConstraints>
     <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/LimitationsOnPublicAccess/noLimitations">Pas de restriction d'accès public</gmx:Anchor>
    </gmd:otherConstraints>
  </gmd:MD_LegalConstraints
</gmd:resourceConstraints>
```

<br/>

```
<gmd:resourceConstraints>
  <gmd:MD_LegalConstraints>
    <gmd:otherConstraints>
      <gco:CharacterString>L124-5-II-2 du code de l'environnement (Directive 2007/2/CE (INSPIRE), Article 13.1.c)</gco:CharacterString>
    </gmd:otherConstraints>
  </gmd:MD_LegalConstraints
</gmd:resourceConstraints>
```

devient :

```
<gmd:resourceConstraints>
  <gmd:MD_LegalConstraints>
    <gmd:otherConstraints>
      <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/LimitationsOnPublicAccess/INSPIRE_Directive_Article13_1c">L124-5-II-2 du code de l'environnement (Directive 2007/2/CE (INSPIRE), Article 13.1.c)</gmx:Anchor>
    </gmd:otherConstraints>
  </gmd:MD_LegalConstraints
</gmd:resourceConstraints>
```



## Références

https://github.com/ecolabdata/ecospheres/wiki/Recommandations-ISO-DCAT#faciliter-la-reconnaissance-des-licences
