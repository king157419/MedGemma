fn init {
  println("Running parser module tests...")
}

test "test_parse_text_report_empty" {
  let result = @parser.parse_text_report("")
  match result {
    Err(msg) => inspect!(msg, content="报告内容不能为空")
    Ok(_) => inspect!("should fail", content="error expected")
  }
}

test "test_parse_text_report_success" {
  let result = @parser.parse_text_report("血常规报告内容")
  match result {
    Ok(report) => inspect!(report.content, content="血常规报告内容")
    Err(_) => inspect!("should succeed", content="success expected")
  }
}

test "test_detect_report_type_blood_routine" {
  let type1 = @parser.detect_report_type("血常规检验报告")
  inspect!(type1, content="blood_routine")
  
  let type2 = @parser.detect_report_type("白细胞计数")
  inspect!(type2, content="blood_routine")
  
  let type3 = @parser.detect_report_type("红细胞检查")
  inspect!(type3, content="blood_routine")
}

test "test_detect_report_type_liver" {
  let type1 = @parser.detect_report_type("肝功能检验")
  inspect!(type1, content="liver_function")
  
  let type2 = @parser.detect_report_type("ALT谷丙转氨酶")
  inspect!(type2, content="liver_function")
}

test "test_detect_report_type_kidney" {
  let type1 = @parser.detect_report_type("肾功能检验")
  inspect!(type1, content="kidney_function")
  
  let type2 = @parser.detect_report_type("肌酐检查")
  inspect!(type2, content="kidney_function")
}

test "test_detect_report_type_lipid" {
  let type1 = @parser.detect_report_type("血脂检验")
  inspect!(type1, content="blood_lipid")
  
  let type2 = @parser.detect_report_type("胆固醇检查")
  inspect!(type2, content="blood_lipid")
  
  let type3 = @parser.detect_report_type("甘油三酯")
  inspect!(type3, content="blood_lipid")
}

test "test_detect_report_type_glucose" {
  let type1 = @parser.detect_report_type("血糖检验")
  inspect!(type1, content="blood_glucose")
  
  let type2 = @parser.detect_report_type("空腹血糖")
  inspect!(type2, content="blood_glucose")
}

test "test_detect_report_type_thyroid" {
  let type1 = @parser.detect_report_type("甲状腺功能")
  inspect!(type1, content="thyroid")
  
  let type2 = @parser.detect_report_type("TSH检查")
  inspect!(type2, content="thyroid")
}

test "test_detect_report_type_general" {
  let type1 = @parser.detect_report_type("其他检查")
  inspect!(type1, content="general")
}

test "test_get_report_type_name" {
  inspect!(@parser.get_report_type_name("blood_routine"), content="血常规检验报告")
  inspect!(@parser.get_report_type_name("liver_function"), content="肝功能检验报告")
  inspect!(@parser.get_report_type_name("kidney_function"), content="肾功能检验报告")
  inspect!(@parser.get_report_type_name("blood_lipid"), content="血脂检验报告")
  inspect!(@parser.get_report_type_name("blood_glucose"), content="血糖检验报告")
  inspect!(@parser.get_report_type_name("thyroid"), content="甲状腺功能检验报告")
  inspect!(@parser.get_report_type_name("unknown"), content="医疗检验报告")
}

test "test_create_detail_item_hemoglobin" {
  let item = @parser.create_detail_item("血红蛋白", "145", "g/L")
  inspect!(item.item_name, content="血红蛋白")
  inspect!(item.value, content="145")
  inspect!(item.unit, content="g/L")
  inspect!(item.normal_range, content="120-160 g/L")
  inspect!(item.status.to_string(), content="正常")
}

test "test_create_detail_item_hemoglobin_high" {
  let item = @parser.create_detail_item("血红蛋白", "180", "g/L")
  inspect!(item.status.to_string(), content="偏高")
}

test "test_create_detail_item_hemoglobin_low" {
  let item = @parser.create_detail_item("血红蛋白", "100", "g/L")
  inspect!(item.status.to_string(), content="偏低")
}

test "test_create_detail_item_wbc" {
  let item = @parser.create_detail_item("白细胞", "7.5", "G/L")
  inspect!(item.status.to_string(), content="正常")
}

test "test_create_detail_item_cholesterol" {
  let item = @parser.create_detail_item("总胆固醇", "5.8", "mmol/L")
  inspect!(item.normal_range, content="3.1-5.7 mmol/L")
  inspect!(item.status.to_string(), content="偏高")
}

test "test_create_detail_item_hdl" {
  let item1 = @parser.create_detail_item("高密度脂蛋白", "1.2", "mmol/L")
  inspect!(item1.status.to_string(), content="正常")
  
  let item2 = @parser.create_detail_item("高密度脂蛋白", "0.8", "mmol/L")
  inspect!(item2.status.to_string(), content="偏低")
}

test "test_create_detail_item_ldl" {
  let item1 = @parser.create_detail_item("低密度脂蛋白", "3.0", "mmol/L")
  inspect!(item1.status.to_string(), content="正常")
  
  let item2 = @parser.create_detail_item("低密度脂蛋白", "4.0", "mmol/L")
  inspect!(item2.status.to_string(), content="偏高")
}

test "test_normalize_item_name" {
  inspect!(@parser.normalize_item_name("血红蛋白"), content="血红蛋白")
  inspect!(@parser.normalize_item_name("HGB"), content="血红蛋白")
  inspect!(@parser.normalize_item_name("ALT"), content="谷丙转氨酶")
  inspect!(@parser.normalize_item_name("AST"), content="谷草转氨酶")
  inspect!(@parser.normalize_item_name("TSH"), content="TSH")
}
