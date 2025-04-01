## Description

Prépare un catalogue à l'utilisation d'ISOmorphe.


## Paramètres

Aucun.


## Prérequis

Aucun.


## Motivation

Les mises à jour de fiches Geonetwork peuvent provoquer des modifications de la structure des fiches XML internes à Geonetwork.

Ce XSLT a pour objectif de :
- provoquer ces modifications internes, pour éviter qu'elles soient mélangées avec les modifications d'autres transformations ISOmorphe ;
- minimiser les modifications internes, en supprimant les namespaces XML inutilisés, pour éviter de générer des modifications liées à ces namespaces inutiles.


## Limites

Cette transformation va modifier l'ensemble des fiches sélectionnées.

Si l'objectif est de restreindre les mises à jour ISOmorphe aux fiches qui seraient réellement affectées par une ou plusieurs autres transformations, l'utilisation de cette transformation de préparation n'est pas recommandée.
Dans la mesure où cette transformation provoque des traitements internes à Geonetwork pouvant être déclenchés par d'autres biais lors de l'utilisation directe de Geonetwork, nous recommandons cependant son usage.

Dans la mesure où les modifications sont ici "internes" à Geonetwork, il peut être souhaitable de ne pas activer l'option "Actualiser la date de mise à jour de la fiche" dans l'étape de mise à jour du catalogue.


## Références

https://github.com/ecolabdata/ecospheres-isomorphe/issues/99

