ALTER TABLE plat ADD column description VARCHAR(255);
ALTER TABLE plat ADD column disponible BOOLEAN NOT NULL DEFAULT TRUE;
ALTER TABLE plat ADD CONSTRAINT chk_prix_positif CHECK (prix > 0);
ALTER TABLE plat ADD CONSTRAINT uk_plat_nom UNIQUE (nom);

/*nouvelle table plat_du_jour	voir ci-dessous
Le plat du jour. On veut savoir quel plat était proposé chaque jour, et il ne peut y en avoir qu’un par jour.

plat_du_jour (date_jour, #id_plat)*/
CREATE TABLE plat_du_jour (
    date_jour DATE PRIMARY KEY,
    id_plat   INTEGER NOT NULL REFERENCES plat(id)
);

