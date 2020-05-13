package cmd

import (
	"bjmes/src/assembly"
	"bjmes/src/log"
	"testing"
)

func Test_DBConfigData(t *testing.T) {
	db := &dbConfigData{
		DgHost:      "r",
		DgUser:      "r",
		DgPwd:       "r",
		DgName:      "r",
		CrystalHost: "r",
		CrystalUser: "r",
		CrystalPwd:  "r",
		CrystalName: "r",
		BdHost:      "r",
		BdUser:      "r",
		BdPwd:       "r",
		BdName:      "r",
	}
	data, err := marshal(db)
	if err != nil {
		t.Fatal(err)
	}
	t.Log(string(data))
}

func init() {
	// 初始化crystal
	assembly.SConfig.CrystalDBHost = "192.168.9.10:6446"
	assembly.SConfig.CrystalDBUser = "crystal_pro"
	assembly.SConfig.CrystalDBPwd = "1z2c3v$ee"
	assembly.SConfig.CrystalDBName = "crystal_pro"
	assembly.InitCrystalDB(false)
	_, err := assembly.CrystalDB.GetDb()
	if err != nil {
		log.Service.Info(err.Error())
		return
	}
	// 初始化吊挂数据
	assembly.SConfig.DGDBHost = "192.168.9.20"
	assembly.SConfig.DGDBUsername = "sa"
	assembly.SConfig.DGDBPassword = "0407Hbn@123"
	assembly.SConfig.DGDBName = "DG_TMP"
	assembly.InitDgDB()
	_, err = assembly.DgDB.GetDb()
	if err != nil {
		return
	}
	//初始化博大
	//assembly.SConfig.PdaDBHost = configData.Db.BdHost
	//assembly.SConfig.PdaDBUsername = configData.Db.BdUser
	//assembly.SConfig.PdaDBPassword = configData.Db.BdPwd
	//assembly.SConfig.PdaDBName = configData.Db.BdName
	//assembly.InitBdDB()
	//_, err = assembly.BdDB.GetDb()
	//if err != nil {
	//	return errors.New("博大数据库连接测试失败")
	//}
}
