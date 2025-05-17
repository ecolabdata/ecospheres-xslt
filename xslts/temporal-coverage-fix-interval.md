## Description

Complète la couverture temporelle lorsque l'intervalle est incomplet.


## Paramètres

Aucun.


## Prérequis

Aucun.


## Motivation

La [spécification GML](https://portal.ogc.org/files/?artifact_id=20509) définit que `gml:TimePeriod` doit contenir une borne de début *et* une borne de fin (section 14.2.2.5).

La borne manquante est ajoutée avec la valeur `unknown`, qui "indique qu'aucune valeur spécifique pour la position temporelle n'est fournie" (section 14.2.2.7).


## Exemples

Lorsque `gml:TimePeriod` ne contient pas de borne de début :

    <gmd:EX_TemporalExtent>
      <gmd:extent>
        <gml:TimePeriod>
          <gml:beginPosition>2021-05-21</gml:beginPosition>
          <!-- début de l'ajout -->
          <gml:endPosition indeterminatePosition="unknown"/>
          <!-- fin de l'ajout -->
        </gml:TimePeriod>
      </gmd:extent>
    </gmd:EX_TemporalExtent>

Lorsque `gml:TimePeriod` ne contient pas de borne de fin :

    <gmd:EX_TemporalExtent>
      <gmd:extent>
        <gml:TimePeriod>
          <!-- début de l'ajout -->
          <gml:beginPosition indeterminatePosition="unknown"/>
          <!-- fin de l'ajout -->
          <gml:endPosition>2021-05-21</gml:beginPosition>
        </gml:TimePeriod>
      </gmd:extent>
    </gmd:EX_TemporalExtent>


## Références

https://github.com/ecolabdata/ecospheres-xslt/issues/31

[OpenGIS Geography Markup Language (GML) Encoding Standard](https://portal.ogc.org/files/?artifact_id=20509), depuis https://www.ogc.org/standards/gml/
