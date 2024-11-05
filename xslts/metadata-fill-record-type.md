## Description

Définit le type de la ressource lorsqu'il est manquant.


## Paramètres

Aucun.


## Motivation

L'utilisation du type "dataset" par défaut correspond au comportement d'autres outils de l'écosystème.


## Exemples

Si `gmd:hierarchyLevel` est absent, la transformation ajoute :

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

https://ecospheres.gitbook.io/recommandations-iso-dcat/adaptation-des-metadonnees-iso-19139-pour-faciliter-la-transformation-en-dcat/veiller-a-ce-que-les-jeux-de-donnees-soient-reconnaissables-comme-tels
