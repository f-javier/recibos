CREATE TABLE `emisor` (
	`codigo` INT(10) NOT NULL AUTO_INCREMENT,
	`nombre` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_spanish_ci',
	`nifcif` VARCHAR(15) NULL DEFAULT NULL COLLATE 'utf8_spanish_ci',
	`direccion` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_spanish_ci',
	`codigopostal` VARCHAR(5) NULL DEFAULT NULL COLLATE 'utf8_spanish_ci',
	`poblacion` VARCHAR(30) NULL DEFAULT NULL COLLATE 'utf8_spanish_ci',
	`provincia` VARCHAR(30) NULL DEFAULT NULL COLLATE 'utf8_spanish_ci',
	`telefono1` VARCHAR(25) NULL DEFAULT NULL COLLATE 'utf8_spanish_ci',
	`telefono2` VARCHAR(25) NULL DEFAULT NULL COLLATE 'utf8_spanish_ci',
	`logotipo` VARCHAR(100) NULL DEFAULT NULL COLLATE 'utf8_spanish_ci',
	PRIMARY KEY (`codigo`)
)
COLLATE='utf8_spanish_ci'
ENGINE=InnoDB
AUTO_INCREMENT=1;

