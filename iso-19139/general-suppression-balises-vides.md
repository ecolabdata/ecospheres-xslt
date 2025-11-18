## Description

Supprime les balises sémantiquement vides.


## Paramètres

Aucun.


## Prérequis

Aucun.


## Motivation

Les balises vides peuvent créer des problèmes tels que :
- Masquer d'autres balises dans les cas où seule la première occurrence d'une balise est prise en compte.
- Valider à tort des contraintes se basant uniquement sur la présence d'une balise sans vérifier le contenu attendu.
- Complexifier inutilement les fiches XML et dans certains cas afficher inutilement les champs équivalents dans les interfaces utilisateurs.


## Limites

Cette transformation fait l'hypothèse qu'une balise vide (ni contenu ni attributs) est sémantiquement équivalent à l'absence de cette balise.

Il peut éventuellement exister des cas particuliers où cette hypothèse s'avère fausse.
Il est donc impératif de vérifier les modifications effectuées par cette transformation avant de les appliquer.


## Exemples

```
<gmd:extent>
  <gml:TimePeriod>
    <gml:beginPosition></gml:beginPosition>
    <gml:endPosition>2014-02-02</gml:endPosition>
  </gml:TimePeriod>
</gmd:extent>
```

devient :

```
<gmd:extent>
  <gml:TimePeriod>
    <gml:endPosition>2014-02-02</gml:endPosition>
  </gml:TimePeriod>
</gmd:extent>
```

<br/>

```
<gmd:citation>
  <gmd:CI_Citation>
    <gmd:title>
      <gco:CharacterString>Titre de la fiche</gco:CharacterString>
    </gmd:title>
    ...
    <gmd:identifier>
      <gmd:MD_Identifier>
        <gmd:code>
          <gco:CharacterString></gco:CharacterString>
        </gmd:code>
      </gmd:MD_Identifier>
    </gmd:identifier>
  </gmd:CI_Citation>
</gmd:citation>
```

devient :

```
<gmd:citation>
  <gmd:CI_Citation>
    <gmd:title>
      <gco:CharacterString>Titre de la fiche</gco:CharacterString>
    </gmd:title>
    ...
    <!-- Toute la section <gmd:identifier> est supprimée car récursivement vide -->
  </gmd:CI_Citation>
</gmd:citation>
```

<br/>

```
<gmd:distributionFormat>
  <gmd:MD_Format>
    <gmd:name gco:nilReason="missing">
      <gco:CharacterString />
    </gmd:name>
    <gmd:version gco:nilReason="unknown">
      <gco:CharacterString />
    </gmd:version>
  </gmd:MD_Format>
</gmd:distributionFormat>
```

devient :

```
<gmd:MD_Distribution>
  <gmd:distributionFormat>
    <gmd:MD_Format>
      <!-- Les balises sans contenu mais possédant des attributs sont préservées -->
      <gmd:name gco:nilReason="missing" />
      <gmd:version gco:nilReason="unknown" />
    </gmd:MD_Format>
  </gmd:distributionFormat>
</gmd:MD_Distribution>
```


## Références

https://github.com/ecolabdata/ecospheres-xslt/issues/24
