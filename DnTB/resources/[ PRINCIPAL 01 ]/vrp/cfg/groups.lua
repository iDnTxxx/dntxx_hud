local cfg = {}

cfg.groups = {
	["xaine"] = {
		"admin.permissao",
		"suporte.permissao",
		"polpar.permissao"
	},
	["Mod"] = {
		"mod.permissao",
		"suporte.permissao",
		"polpar.permissao"
	},
	["Sup"] = {
		"suporte.permissao"
	},
	["olhinho"] = {
		_config = {
			title = "Monster",
			gtype = "jobdois",
		},
		"monster.permissao"
	},
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETS LIDER
-----------------------------------------------------------------------------------------------------------------------------------------
	["Chefepolicia"] = {
		_config = {
			title = "Chief Police",
			gtype = "job2"
		},
		"setpolicia.permissao",
		"player.blips"
	},
	["liderparamedico"] = {
		_config = {
			title = "Lider Paramedico",
			gtype = "job2"
		},
		"setparamedico.permissao",
		"player.blips"
	},
	["lidermecanico"] = {
		_config = {
			title = "Lider Mecanico",
			gtype = "job2"
		},
		"setmecanico.permissao",
		"player.blips"
	},
	["Concessionaria"] = {
		_config = {
			title = "Concessionaria",
			gtype = "job"
		},
		"conce.permissao",
		"sem.permissao"
	},
	["Booster"] = {
		_config = {
			title = "Booster",
			gtype = "booster"
		},
		"booster.permissao",
		"sem.permissao"
	},
-----------------------------------------------------------------------------------------------------------------------------------------
-- TAGS POLICIA
-----------------------------------------------------------------------------------------------------------------------------------------
	["Toogle2"] = {
		_config = {
			title = "Policia em Ação",
			gtype = "job"
		},
		"toogle2.permissao",
		"mochila.permissao",
		"avisos.permissao"
	},
	["Policia"] = {
		_config = {
			title = "Police",
			gtype = "job"
		},
		"policia.permissao",
		"polpar.permissao",
		"portadp.permissao",
		"salario.permissao",
		"toogle2.permissao",
		"avisos.permissao",
		"sem.permissao"
	},	
	["PaisanaPolicia"] = {
		_config = {
			title = "PaisanaPolice",
			gtype = "job"
		},
		"paisanapolicia.permissao",
		"sem.permissao"
	},
	["Paramedico"] = {
		_config = {
			title = "Hospital",
			gtype = "job"
		},
		"paramedico.permissao",
		"polpar.permissao",
		"sem.permissao"
	}, 	
	["PaisanaParamedico"] = {
		_config = {
			title = "PaisanaParamedico",
			gtype = "job"
		},
		"paisanaparamedico.permissao",
		"sem.permissao"
	},
	["Mecanico"] = {
		_config = {
			title = "Mecanico",
			gtype = "job"
		},
		"mecanico.permissao",
		"sem.permissao"
	},
	["PaisanaMecanico"] = {
		_config = {
			title = "PaisanaMecanico",
			gtype = "job"
		},
		"paisanamecanico.permissao"
	},
	["Taxista"] = {
		"taxista.permissao",
		"sem.permissao"
	},
	["PaisanaTaxista"] = {
		"paisanataxista.permissao",
		"sem.permissao"
	},
-----------------------------------------------------------------------------------------------------------------------------------------
-- VIPS
-----------------------------------------------------------------------------------------------------------------------------------------
	["Ultimate"] = {
		_config = {
			title = "Ultimate",
			gtype = "vip"
		},
		"ultimate.permissao",
		"mochila.permissao"
	},
	["Last"] = {
		_config = {
			title = "Supremo",
			gtype = "vip"
		},
		"last.permissao",
		"mochila.permissao"
	},
	["Hire"] = {
		_config = {
			title = "Hire",
			gtype = "vip"
		},
		"hire.permissao"
		--"mochila.permissao"
	},
-----------------------------------------------------------------------------------------------------------------------------------------
-- GANGUES
-----------------------------------------------------------------------------------------------------------------------------------------
	["Ballas"] = {
		_config = {
			title = "Ballas",
			gtype = "job"
		},
		"ballas.permissao",
		"trafico.permissao",
		"ilegal.permissao",
		"drogas.permissao"
	},
	["Vagos"] = {
		_config = {
			title = "Vagos",
			gtype = "job"
		},
		"vagos.permissao",
		"trafico.permissao",
		"ilegal.permissao",
		"drogas.permissao"
	},
	["Groove"] = {
		_config = {
			title = "Groove",
			gtype = "job"
		},
		"grove.permissao",
		"trafico.permissao",
		"ilegal.permissao",
		"drogas.permissao"
	},
	["Crips"] = {
		_config = {
			title = "Crips",
			gtype = "job"
		},
		"crips.permissao",
		"trafico.permissao",
		"ilegal.permissao",
		"armas.permissao"
	},
	["Bloods"] = {
		_config = {
			title = "Bloods",
			gtype = "job"
		},
		"blood.permissao",
		"trafico.permissao",
		"ilegal.permissao",
		"armas.permissao"

	},
	["Triade"] = {
		_config = {
			title = "Triade",
			gtype = "job"
		},
		"mafia.permissao",
		"ilegal.permissao",
		"municoes.permissao"
	},
	["Bratva"] = {
		_config = {
			title = "Bratva",
			gtype = "job"
		},
		"brt.permissao",
		"ilegal.permissao",
		"municoes.permissao"
	},
	["Bahamas"] = {
		_config = {
			title = "Bahamas",
			gtype = "job"
		},
		"bahamas.permissao",
		"ilegal.permissao",
		"lavagem.permissao"
	},
	["MotoClub"] = {
		_config = {
			title = "MotoClub",
			gtype = "job"
		},
		"motoclub.permissao",
		"ilegal.permissao"
	},
	["LifeInvader"] = {
		_config = {
			title = "LifeInvader",
			gtype = "job"
		},
		"lifeinvader.permissao",
		"ilegal.permissao",
		"lavagem.permissao"
	},		
}

cfg.users = {
	[0] = { "xaine" },
	[1] = { "xaine" },
	[2] = { "xaine" }
}

cfg.selectors = {}

return cfg