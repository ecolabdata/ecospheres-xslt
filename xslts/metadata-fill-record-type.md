## Description

Définit le type de la ressource lorsqu'il est manquant.


## Paramètres

Aucun.


## Motivation

L'utilisation du type "dataset" par défaut correspond au comportement d'autres outils de l'écosystème.


## Exemples

Lorsque `gmd:hierarchyLevel` est absent, la transformation ajoute :

    <gmd:MD_Metadata...>
      <gmd:fileIdentifier>...</gmd:fileIdentifier>
      <gmd:language>...</gmd:language>
      <gmd:characterSet>...</gmd:characterSet>
      <!-- début de l'ajout -->
      <gmd:hierarchyLevel>
        <gmd:MD_ScopeCode codeList="http://standards.iso.org/iso/19139/resources/gmxCodelists.xml#MD_ScopeCode" codeListValue="dataset"/>
      </gmd:hierarchyLevel>
      <!-- fin de l'ajout -->


## Références

https://github.com/ecolabdata/ecospheres/wiki/Recommandations-ISO-DCAT#veiller-%C3%A0-ce-que-les-jeux-de-donn%C3%A9es-soient-reconnaissables-comme-tels
