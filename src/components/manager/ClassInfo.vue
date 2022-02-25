<template>
<div>
<div><H4 style="color:purple;">課程明細</H4></div>    
<div style="padding: 20px;">
<div class="input-group" style="padding-left: 10px;padding-right: 10px;width: 100%;">
    <div class="input-group-prepend" style="margin-left: 0px;"><span class="input-group-text" style="width: 140px">類別代碼<br></span></div>
        <select v-model="currentClassGroup" class="form-control" style="width: 80px">
            <optgroup label="類別代碼">
                <Option v-for="(item,index) in this.ClassCatList" 
                        :value="item" 
                        :key="index"
                        >{{ item }}
                </Option>
            </optgroup>
        </select>                                 
    <div class="input-group-append"></div>
    <div class="input-group-prepend" style="margin-left: 0px;"><span class="input-group-text" style="width: 140px">班別代碼<br></span></div>
        <select v-model="currentClassCode" class="form-control" style="width: 80px">
            <optgroup label="班別類別">
                <Option v-for="(item,index) in this.ClassCodeList" 
                        :value="item" 
                        :key="index"
                        >{{ item }}
                </Option>
            </optgroup>
        </select>                                 
    <div class="input-group-append"></div>
    <div class="input-group-prepend" style="margin-left: 0px;"><span class="input-group-text" style="width: 140px">班別序號<br></span></div>
        <select v-model="currentClassSeq" class="form-control" style="width: 80px">
            <optgroup label="班別類別">
                <Option v-for="(item,index) in this.ClassSeqList" 
                        :value="item" 
                        :key="index"
                        >{{ item }}
                </Option>
            </optgroup>
        </select>                                 
    <div class="input-group-append"></div>
    <div class="input-group-prepend" style="margin-left: 0px;"><span class="input-group-text" style="width: 140px">班別年度<br></span></div>
        <select v-model="currentClassAnnual" class="form-control" style="width: 80px">
            <optgroup label="班別類別">
                <Option v-for="(item,index) in this.ClassAnnualList" 
                        :value="item" 
                        :key="index"
                        >{{ item }}
                </Option>
            </optgroup>
        </select>                                 
    <div class="input-group-append"></div>
    <div><button v-on:click="searchClassInfo" class="btn btn-primary btn-lg" id="send" style="height:35px; font-size:18px">查詢</button></div>                  
</div>
</div>  
<div ref="divWrapper" style="padding: 30px">
    <Grid
        ref="grid"
        :style="{height: '500px', width:'100%'}"
        :resizable="true"
        :data-items="ClassInfos"
        :selected-field="selectedField"
        :columns="columns"
        :pageable="true"
        :skip= "skip"
        :take="take"
        :total="total"
        @pagechange="pageChangeHandler"
        >      
        <template v-slot:myTemplate="{props}">
            <custom :data-item="props.dataItem" 
                    @duplicate="duplicate"
                    @giveClass="giveClass"
                    @printDoc="printDoc"
                    @edit="edit"
                    @remove="remove"/>
        </template>       
        <grid-toolbar>
            <button title="新增課程"
                    class="k-button k-primary"
                    @click='OpenAddNews' >
                新增
            </button>
        </grid-toolbar>      
        <grid-norecords name="classInfo-grid-norecords">
           <div  class="k-loading-mask customPosition"><span class='k-loading-text'></span><div class='k-loading-image'/><div class='k-loading-color'/></div>
        </grid-norecords>            
    </Grid>
</div>
<div id="container" class="modal-dialog">
    <b-modal id="bv-modal" hide-footer hide-header-close no-close-on-esc no-close-on-backdrop>
        <template #modal-title>
        編輯課程
        </template>    
        <form  @submit.prevent="onSubmit">
            <!-- <form> -->
            <div class="form-group">
            <div margin-left="auto" margin-right="auto">   
                <div class="form-row" style="margin-right: 0px;margin-left: 0px;width: 100%;">
                    <div class="col-md-4" style="padding-left: 0px;margin-left: 0px;">
                        <div class="input-group" style="padding-left: 10px;padding-right: 10px;">
                            <div class="input-group-prepend">
                            <span class="input-group-text" style="width: 100px;color: rgb(73,80,78);padding-left: 12px;margin-left: 0px;">類別代碼<br></span></div>
                            <select class="form-control"   @change="ClassCat_onChange_Add($event)" required>
                                    <Option v-for="(item,index) in this.ClassCatList" 
                                            :required="true"
                                            :value="item" 
                                            :key="index"
                                            :selected="item == ClassInfoEdit.classGroup"
                                            >{{ item }}
                                    </Option>
                            </select>                       
                            <div class="input-group-append"></div>
                        </div>
                    </div>
                    <div class="col-md-4" style="padding-left: 0px;margin-left: 0px;">
                        <div class="input-group" style="padding-left: 10px;padding-right: 10px;">
                            <div class="input-group-prepend">
                            <span class="input-group-text" style="width: 100px;color: rgb(73,80,78);padding-left: 12px;margin-left: 0px;">班別代號<br></span></div>
                            <input v-model="ClassInfoEdit.classCode" class="form-control" type="text" id="classCode" required>
                            <div class="input-group-append"></div>
                        </div>
                    </div>

                    <div class="col-md-4" style="padding-left: 0px;margin-left: 0px;">
                        <div class="input-group" style="padding-left: 10px;padding-right: 10px;">
                            <div class="input-group-prepend">
                            <span class="input-group-text" style="width: 100px;color: rgb(73,80,78);padding-left: 12px;margin-left: 0px;">課程序號<br></span></div>
                            <input v-model.number="ClassInfoEdit.classSeq" class="form-control" type="number"  min="0" style="margin-right: 0px;padding-left: 10px;" required="" />
                            <div class="input-group-append"></div>
                        </div>
                    </div>  

                    <div class="col-md-4" style="padding-left: 0px;margin-left: 0px;">
                        <div class="input-group" style="padding-left: 10px;padding-right: 10px;">
                            <div class="input-group-prepend">
                            <span class="input-group-text" style="width: 100px;color: rgb(73,80,78);padding-left: 12px;margin-left: 0px;">課程年度<br></span></div>
                            <input v-model.number="ClassInfoEdit.classAnnual" class="form-control" type="number"  min="111" style="margin-right: 0px;padding-left: 10px;" required="" />
                            <div class="input-group-append"></div>
                        </div>
                    </div>  

                </div>
                <div class="input-group" style="padding-left: 10px;padding-right: 10px;width: 100%;">
                    <div class="input-group-prepend" style="margin-left: 0px;"><span class="input-group-text" style="width: 150px">類別名稱<br></span></div>
                    <input v-model="ClassInfoEdit.classCatName" class="form-control" readonly="readonly" type="text" style="margin-right: 0px;padding-left: 10px;" />
                    <div class="input-group-append"></div>
                </div>                    
                <div class="input-group" style="padding-left: 10px;padding-right: 10px;width: 100%;">
                    <div class="input-group-prepend" style="margin-left: 0px;"><span class="input-group-text" style="width: 150px;">課程名稱<br></span></div>
                    <input v-model="ClassInfoEdit.className" class="form-control" type="text" style="margin-right: 0px;padding-left: 10px;" required>
                    <div class="input-group-append"></div>
                </div>    
                <div class="input-group" style="padding-left: 10px;padding-right: 10px;width: 100%;">
                    <div class="input-group-prepend" style="margin-left: 0px;"><span class="input-group-text" style="width: 150px">課程地點<br></span></div>
                    <select class="form-control select-editable" required>
                            <Option v-for="(item,index) in ClassCatLocations" 
                                    :required="true"
                                    :value="item" 
                                    :key="index"
                                    :selected="item == ClassInfoEdit.classLocation"
                                    >{{ item }}
                            </Option>
                    </select>                        
                    <div class="input-group-append"></div>
                </div>          
                <div class="form-row" style="margin-right: 0px;margin-left: 0px;width: 100%;">
                    <div class="col-md-6" style="padding-left: 0px;margin-left: 0px;">
                        <div class="input-group" style="padding-left: 10px;padding-right: 10px;">
                        <div class="input-group-prepend">
                        <span class="input-group-text" style="width: 150px;color: rgb(73,80,78);padding-left: 12px;margin-left: 0px;" required>課程日期起<br></span></div>
                        <input v-model='ClassInfoEdit.classStartDate' type="date" class="form-control" id="classStartDate" required="" oninvalid="checkBirthDay(this);">
                        <div class="input-group-append"></div>
                        </div>
                    </div>
                    <div class="col-md-6" style="padding-left: 0px;margin-left: 0px;">
                        <div class="input-group" style="padding-left: 10px;padding-right: 10px;">
                        <div class="input-group-prepend">
                        <span class="input-group-text" style="width: 150px;color: rgb(73,80,78);padding-left: 12px;margin-left: 0px;" required>課程日期迄<br></span></div>
                        <input v-model="ClassInfoEdit.classEndDate" type="date" class="form-control"  id="classEndDate" required="" oninvalid="checkBirthDay(this);">
                        <div class="input-group-append"></div>
                        </div>
                    </div>
                </div>
                <div class="form-row" style="margin-right: 0px;margin-left: 0px;width: 100%;">
                    <div class="col-md-6" style="padding-left: 0px;margin-left: 0px;">   
                        <div class="input-group" style="padding-left: 10px;padding-right: 10px;width: 100%;">
                            <div class="input-group-prepend" style="margin-left: 0px;"><span class="input-group-text" style="width: 150px;">天數<br></span></div>
                            <input v-model.number="ClassInfoEdit.classDays" class="form-control" type="number"  min="0" style="margin-right: 0px;padding-left: 10px;" required="" />
                            <div class="input-group-append"></div>
                        </div>    
                    </div>
                    <div class="col-md-6" style="padding-left: 0px;margin-left: 0px;">     
                        <div class="input-group" style="padding-left: 10px;padding-right: 10px;width: 100%;">
                            <div class="input-group-prepend" style="margin-left: 0px;"><span class="input-group-text" style="width: 150px">時數<br></span></div>
                            <input v-model.number="ClassInfoEdit.classHours" class="form-control" type="number" min="0" style="margin-right: 0px;padding-left: 10px;" required=""  />
                            <div class="input-group-append"></div>
                        </div> 
                    </div>
                </div>      
                <div class="input-group" style="padding-left: 10px;padding-right: 10px;width: 100%;">
                    <div class="input-group-prepend" style="margin-left: 0px;"><span class="input-group-text" style="width: 150px">課程內容<br></span></div><input v-model="ClassInfoEdit.classContent" class="form-control" type="text" style="margin-right: 0px;padding-left: 10px;" />
                    <div class="input-group-append"></div>
                </div> 
                <div class="form-row" style="margin-right: 0px;margin-left: 0px;width: 100%;">
                    <div class="col-md-6" style="padding-left: 0px;margin-left: 0px;"> 
                        <div class="input-group" style="padding-left: 10px;padding-right: 10px;width: 100%;">
                            <div class="input-group-prepend" style="margin-left: 0px;"><span class="input-group-text" style="width: 150px">學雜費<br></span></div>
                            <input v-model.number="ClassInfoEdit.tuition" class="form-control" type="number"  min="0" style="margin-right: 0px;padding-left: 10px;" required=""  />
                            <div class="input-group-append"></div>
                        </div>     
                    </div>
                    <div class="col-md-6" style="padding-left: 0px;margin-left: 0px;"> 
                        <div class="input-group" style="padding-left: 10px;padding-right: 10px;width: 100%;">
                            <div class="input-group-prepend" style="margin-left: 0px;"><span class="input-group-text" style="width: 150px;">學雜費說明<br></span></div><input v-model="ClassInfoEdit.tuitionMemo" class="form-control" type="text" style="margin-right: 0px;padding-left: 10px;">
                            <div class="input-group-append"></div>
                        </div>     
                    </div>
                </div>
                <div class="form-row" style="margin-right: 0px;margin-left: 0px;width: 100%;">
                    <div class="col-md-6" style="padding-left: 0px;margin-left: 0px;"> 
                        <div class="input-group" style="padding-left: 10px;padding-right: 10px;width: 100%;">
                            <div class="input-group-prepend" style="margin-left: 0px;"><span class="input-group-text" style="width: 150px">是否供餐<br></span></div>
                            <select v-model="ClassInfoEdit.provideMeal" class="form-control">
                            <option>是</option>
                            <option>否</option>
                            </select>
                            <div class="input-group-append"></div>
                        </div>   
                    </div> 
                    <div class="col-md-6" style="padding-left: 0px;margin-left: 0px;">                  
                        <div class="input-group" style="padding-left: 10px;padding-right: 10px;width: 100%;">
                            <div class="input-group-prepend" style="margin-left: 0px;"><span class="input-group-text" style="width: 150px;">供餐說明<br></span></div>
                            <input v-model="ClassInfoEdit.mealMemo" class="form-control" type="text" style="margin-right: 0px;padding-left: 10px;">
                            <div class="input-group-append"></div>
                        </div>  
                    </div> 
                </div> 
                <div class="form-row" style="margin-right: 0px;margin-left: 0px;width: 100%;">
                    <div class="col-md-6" style="padding-left: 0px;margin-left: 0px;"> 
                        <div class="input-group" style="padding-left: 10px;padding-right: 10px;width: 100%;">
                            <div class="input-group-prepend" style="margin-left: 0px;"><span class="input-group-text" style="width: 150px">是否提供住宿<br></span></div>
                            <select v-model="ClassInfoEdit.provideAccommodation" class="form-control" value="否">
                            <option>是</option>
                            <option>否</option>
                            </select>                            
                            <div class="input-group-append"></div>
                        </div>         
                    </div>
                    <div class="col-md-6" style="padding-left: 0px;margin-left: 0px;">            
                        <div class="input-group" style="padding-left: 10px;padding-right: 10px;width: 100%;">
                            <div class="input-group-prepend" style="margin-left: 0px;"><span class="input-group-text" style="width: 150px;">住宿費<br></span></div>
                            <input v-model.number="ClassInfoEdit.accommodationFee" class="form-control" type="number"  min="0" style="margin-right: 0px;padding-left: 10px;" value='0' required=""  >
                            <div class="input-group-append"></div>
                        </div>     
                    </div>
                </div>
                <div class="form-row" style="margin-right: 0px;margin-left: 0px;width: 100%;">
                    <div class="col-md-6" style="padding-left: 0px;margin-left: 0px;"> 
                        <div class="input-group" style="padding-left: 10px;padding-right: 10px;width: 100%;">
                            <div class="input-group-prepend" style="margin-left: 0px;"><span class="input-group-text" style="width: 150px">住宿費說明<br></span></div><input v-model="ClassInfoEdit.accommodationMemo" class="form-control" type="text" style="margin-right: 0px;padding-left: 10px;" />
                            <div class="input-group-append"></div>
                        </div>       
                    </div>
                    <div class="col-md-6" style="padding-left: 0px;margin-left: 0px;">             
                        <div class="input-group" style="padding-left: 10px;padding-right: 10px;width: 100%;">
                            <div class="input-group-prepend" style="margin-left: 0px;"><span class="input-group-text" style="width: 150px;">顯示<br></span></div>
                            <select v-model="ClassInfoEdit.show" class="form-control" value="否">
                            <option>是</option>
                            <option>否</option>
                            </select>
                            <div class="input-group-append"></div>
                        </div>     
                    </div>
                    <div class="col-md-6" style="padding-left: 0px;margin-left: 0px;">             
                        <div class="input-group" style="padding-left: 10px;padding-right: 10px;width: 100%;">
                            <div class="input-group-prepend" style="margin-left: 0px;"><span class="input-group-text" style="width: 150px;">開課<br></span></div>
                            <select v-model="ClassInfoEdit.giveCourse" class="form-control" value="否">
                            <option>是</option>
                            <option>否</option>
                            </select>
                            <div class="input-group-append"></div>
                        </div>     
                    </div>
                </div>       
            </div>

            <div class="d-xl-flex justify-content-xl-center align-items-xl-center" style="text-align: center;height: 0px;padding-top: 30px;">
                <button type="submit" class="btn btn-primary" style="margin: 5px;" id="send">儲存變更</button>
                <button  type="button" class="btn btn-secondary" style="margin: 5px;" @click="$bvModal.hide('bv-modal');CancelEdit();">關閉</button>
            </div>
            
            </div>
        </form>
        <br/>
    </b-modal>
</div> 
<div id="containerAddNews" class="modal-dialog modal-lg">
    <b-modal id="bv-modal-add-news" hide-footer  hide-header-close no-close-on-esc no-close-on-backdrop>
        <template #modal-title>
        新增課程明細
        </template>    
        <form  @submit.prevent="onSubmitAddNews">
            <!-- <form> -->
            <div class="form-group">
            <div margin-left="auto" margin-right="auto">   
                <div class="form-row" style="margin-right: 0px;margin-left: 0px;width: 100%;">

                    <div class="col-md-4" style="padding-left: 0px;margin-left: 0px;">
                        <div class="input-group" style="padding-left: 10px;padding-right: 10px;">
                            <div class="input-group-prepend"><span class="input-group-text" style="width: 100px;color: rgb(73,80,78);padding-left: 12px;margin-left: 0px;">類別代碼<br></span></div>
                            <select class="form-control" @change="ClassCat_onChange_Add($event)" required v-model="ClassInfoAdd.classGroup">
                                    <Option v-for="(item,index) in this.ClassCatList" 
                                            :required="true"
                                            :value="item" 
                                            :key="index"
                                            :selected="item == ClassInfoAdd.classGroup"
                                            >{{ item }}
                                    </Option>
                            </select>                       
                            <div class="input-group-append"></div>
                        </div>
                    </div>

                    <div class="col-md-4" style="padding-left: 0px;margin-left: 0px;">
                        <div class="input-group" style="padding-left: 10px;padding-right: 10px;">
                            <div class="input-group-prepend"><span class="input-group-text" style="width: 100px;color: rgb(73,80,78);padding-left: 12px;margin-left: 0px;">班別代號<br></span></div>
                            <input v-model="ClassInfoAdd.classCode" class="form-control" type="text" id="classCode" required>
                            <div class="input-group-append"></div>
                        </div>
                    </div>

                    <div class="col-md-4" style="padding-left: 0px;margin-left: 0px;">
                        <div class="input-group" style="padding-left: 10px;padding-right: 10px;">
                            <div class="input-group-prepend">
                                <span class="input-group-text" style="width: 100px;color: rgb(73,80,78);padding-left: 12px;margin-left: 0px;">課程序號<br></span></div>
                            <input v-model.number="ClassInfoAdd.classSeq" class="form-control" type="number"  min="0" style="margin-right: 0px;padding-left: 10px;" required="" />
                            <div class="input-group-append"></div>
                        </div>
                    </div>   

                    <div class="col-md-4" style="padding-left: 0px;margin-left: 0px;">
                        <div class="input-group" style="padding-left: 10px;padding-right: 10px;">
                            <div class="input-group-prepend">
                                <span class="input-group-text" style="width: 100px;color: rgb(73,80,78);padding-left: 12px;margin-left: 0px;">課程年度<br></span></div>
                            <input v-model.number="ClassInfoAdd.classAnnual" class="form-control" type="number"  min="111" style="margin-right: 0px;padding-left: 10px;" required="" />
                            <div class="input-group-append"></div>
                        </div>
                    </div>   

                </div>
                <div class="input-group" style="padding-left: 10px;padding-right: 10px;width: 100%;">
                    <div class="input-group-prepend" style="margin-left: 0px;"><span class="input-group-text" style="width: 150px">類別名稱<br></span></div>
                    <input v-model="ClassInfoAdd.classCatName" class="form-control" readonly="readonly" type="text" style="margin-right: 0px;padding-left: 10px;" />
                    <div class="input-group-append"></div>
                </div>                    
                <div class="input-group" style="padding-left: 10px;padding-right: 10px;width: 100%;">
                    <div class="input-group-prepend" style="margin-left: 0px;"><span class="input-group-text" style="width: 150px;">課程名稱<br></span></div>
                    <input v-model="ClassInfoAdd.className" class="form-control" type="text" style="margin-right: 0px;padding-left: 10px;" required>
                    <div class="input-group-append"></div>
                </div>    
                <div class="input-group" style="padding-left: 10px;padding-right: 10px;width: 100%;">
                    <div class="input-group-prepend" style="margin-left: 0px;"><span class="input-group-text" style="width: 150px">課程地點<br></span></div>
                    <select class="form-control select-editable" required v-model="ClassInfoAdd.classLocation">
                            <Option v-for="(item,index) in ClassCatLocations" 
                                    :required="true"
                                    :value="item" 
                                    :key="index"
                                    :selected="item == ClassInfoAdd.classLocation"
                                    >{{ item }}
                            </Option>
                    </select>                        
                    <div class="input-group-append"></div>
                </div>          
                <div class="form-row" style="margin-right: 0px;margin-left: 0px;width: 100%;">
                    <div class="col-md-6" style="padding-left: 0px;margin-left: 0px;">
                        <div class="input-group" style="padding-left: 10px;padding-right: 10px;">
                            <div class="input-group-prepend"><span class="input-group-text" style="width: 150px;color: rgb(73,80,78);padding-left: 12px;margin-left: 0px;" required>課程日期起<br></span></div>
                            <input v-model="ClassInfoAdd.classStartDate" type="date" class="form-control" id="classStartDate" required="" oninvalid="checkBirthDay(this);">
                            <div class="input-group-append"></div>
                        </div>
                    </div>
                    <div class="col-md-6" style="padding-left: 0px;margin-left: 0px;">
                        <div class="input-group" style="padding-left: 10px;padding-right: 10px;">
                            <div class="input-group-prepend"><span class="input-group-text" style="width: 150px;color: rgb(73,80,78);padding-left: 12px;margin-left: 0px;" required>課程日期迄<br></span></div>
                            <input v-model="ClassInfoAdd.classEndDate" type="date" class="form-control"  id="classEndDate" required="" oninvalid="checkBirthDay(this);">
                            <div class="input-group-append"></div>
                        </div>
                    </div>
                </div>
                <div class="form-row" style="margin-right: 0px;margin-left: 0px;width: 100%;">
                    <div class="col-md-6" style="padding-left: 0px;margin-left: 0px;">   
                        <div class="input-group" style="padding-left: 10px;padding-right: 10px;width: 100%;">
                            <div class="input-group-prepend" style="margin-left: 0px;"><span class="input-group-text" style="width: 150px;">天數<br></span></div>
                            <input v-model.number="ClassInfoAdd.classDays" class="form-control" type="number"  min="0" style="margin-right: 0px;padding-left: 10px;" required="" />
                            <div class="input-group-append"></div>
                        </div>    
                    </div>
                    <div class="col-md-6" style="padding-left: 0px;margin-left: 0px;">     
                        <div class="input-group" style="padding-left: 10px;padding-right: 10px;width: 100%;">
                            <div class="input-group-prepend" style="margin-left: 0px;"><span class="input-group-text" style="width: 150px">時數<br></span></div>
                            <input v-model.number="ClassInfoAdd.classHours" class="form-control" type="number" min="0" style="margin-right: 0px;padding-left: 10px;" required=""  />
                            <div class="input-group-append"></div>
                        </div> 
                    </div>
                </div>      
                <div class="input-group" style="padding-left: 10px;padding-right: 10px;width: 100%;">
                    <div class="input-group-prepend" style="margin-left: 0px;"><span class="input-group-text" style="width: 150px">課程內容<br></span></div><input v-model="ClassInfoAdd.classContent" class="form-control" type="text" style="margin-right: 0px;padding-left: 10px;" />
                    <div class="input-group-append"></div>
                </div> 
                <div class="form-row" style="margin-right: 0px;margin-left: 0px;width: 100%;">
                    <div class="col-md-6" style="padding-left: 0px;margin-left: 0px;"> 
                        <div class="input-group" style="padding-left: 10px;padding-right: 10px;width: 100%;">
                            <div class="input-group-prepend" style="margin-left: 0px;"><span class="input-group-text" style="width: 150px">學雜費<br></span></div>
                            <input v-model.number="ClassInfoAdd.tuition" class="form-control" type="number"  min="0" style="margin-right: 0px;padding-left: 10px;" required=""  />
                            <div class="input-group-append"></div>
                        </div>     
                    </div>
                    <div class="col-md-6" style="padding-left: 0px;margin-left: 0px;"> 
                        <div class="input-group" style="padding-left: 10px;padding-right: 10px;width: 100%;">
                            <div class="input-group-prepend" style="margin-left: 0px;"><span class="input-group-text" style="width: 150px;">學雜費說明<br></span></div><input v-model="ClassInfoAdd.tuitionMemo" class="form-control" type="text" style="margin-right: 0px;padding-left: 10px;">
                            <div class="input-group-append"></div>
                        </div>     
                    </div>
                </div>
                <div class="form-row" style="margin-right: 0px;margin-left: 0px;width: 100%;">
                    <div class="col-md-6" style="padding-left: 0px;margin-left: 0px;"> 
                        <div class="input-group" style="padding-left: 10px;padding-right: 10px;width: 100%;">
                            <div class="input-group-prepend" style="margin-left: 0px;"><span class="input-group-text" style="width: 150px">是否供餐<br></span></div>
                            <select v-model="ClassInfoAdd.provideMeal" class="form-control">
                            <option>是</option>
                            <option>否</option>
                            </select>
                            <div class="input-group-append"></div>
                        </div>   
                    </div> 
                    <div class="col-md-6" style="padding-left: 0px;margin-left: 0px;">                  
                        <div class="input-group" style="padding-left: 10px;padding-right: 10px;width: 100%;">
                            <div class="input-group-prepend" style="margin-left: 0px;"><span class="input-group-text" style="width: 150px;">供餐說明<br></span></div>
                            <input v-model="ClassInfoAdd.mealMemo" class="form-control" type="text" style="margin-right: 0px;padding-left: 10px;">
                            <div class="input-group-append"></div>
                        </div>  
                    </div> 
                </div> 
                <div class="form-row" style="margin-right: 0px;margin-left: 0px;width: 100%;">
                    <div class="col-md-6" style="padding-left: 0px;margin-left: 0px;"> 
                        <div class="input-group" style="padding-left: 10px;padding-right: 10px;width: 100%;">
                            <div class="input-group-prepend" style="margin-left: 0px;"><span class="input-group-text" style="width: 150px">是否提供住宿<br></span></div>
                            <select v-model="ClassInfoAdd.provideAccommodation" class="form-control" value="否">
                            <option>是</option>
                            <option>否</option>
                            </select>                            
                            <div class="input-group-append"></div>
                        </div>         
                    </div>
                    <div class="col-md-6" style="padding-left: 0px;margin-left: 0px;">            
                        <div class="input-group" style="padding-left: 10px;padding-right: 10px;width: 100%;">
                            <div class="input-group-prepend" style="margin-left: 0px;"><span class="input-group-text" style="width: 150px;">住宿費<br></span></div>
                            <input v-model.number="ClassInfoAdd.accommodationFee" class="form-control" type="number"  min="0" style="margin-right: 0px;padding-left: 10px;" value='0' required=""  >
                            <div class="input-group-append"></div>
                        </div>     
                    </div>
                </div>
                <div class="form-row" style="margin-right: 0px;margin-left: 0px;width: 100%;">
                    <div class="col-md-6" style="padding-left: 0px;margin-left: 0px;"> 
                        <div class="input-group" style="padding-left: 10px;padding-right: 10px;width: 100%;">
                            <div class="input-group-prepend" style="margin-left: 0px;"><span class="input-group-text" style="width: 150px">住宿費說明<br></span></div><input v-model="ClassInfoAdd.accommodationMemo" class="form-control" type="text" style="margin-right: 0px;padding-left: 10px;" />
                            <div class="input-group-append"></div>
                        </div>       
                    </div>
                    <div class="col-md-6" style="padding-left: 0px;margin-left: 0px;">             
                        <div class="input-group" style="padding-left: 10px;padding-right: 10px;width: 100%;">
                            <div class="input-group-prepend" style="margin-left: 0px;"><span class="input-group-text" style="width: 150px;">顯示<br></span></div>
                            <select v-model="ClassInfoAdd.show" class="form-control" value="否">
                            <option>是</option>
                            <option>否</option>
                            </select>
                            <div class="input-group-append"></div>
                        </div>     
                    </div>
                </div>       
            </div>
            <div class="d-xl-flex justify-content-xl-center align-items-xl-center" style="text-align: center;height: 0px;padding-top: 30px;">
                <button type="submit" class="btn btn-primary" style="margin: 5px;" id="send">新增課程</button>
                <button  type="button" class="btn btn-secondary" style="margin: 5px;" @click="$bvModal.hide('bv-modal-add-news');CancelAdd();">關閉</button>
            </div>

            </div>
        </form>
        <br/>
    </b-modal>
</div> 
    <vue-toastr ref="toastr"></vue-toastr>         
</div>
</template>

<style scoped src="../../assets/register/bootstrap/css/register.bootstrap.min.css"></style>
<style scoped src="../../assets/register/css/register.css"></style>
<script src="../../assets/register/js/register.js"></script>
<script>
import axios from 'axios';
import { Grid, GridToolbar, GridNoRecords } from '@progress/kendo-vue-grid';
import Vue from 'vue';
import VueToast from 'vue-toast-notification';
import 'vue-toast-notification/dist/theme-sugar.css';
import $ from 'jquery';
import '@progress/kendo-ui'
import '@progress/kendo-theme-default/dist/all.css'
import '@progress/kendo-ui/js/messages/kendo.messages.zh-TW.js'
import { NumericTextBox } from '@progress/kendo-inputs-vue-wrapper';
import edit_remove_duplicate_GiveClass_CommandCell from './CommandCell/edit_remove_duplicate_GiveClass_CommandCell.vue';
Vue.use(VueToast);
var moment = require('moment');
/* eslint-disable no-debugger, no-console */
export default {
    name:"ClassInfo",
    components: {
        'Grid': Grid,
        'grid-toolbar': GridToolbar,
        'custom': edit_remove_duplicate_GiveClass_CommandCell,
    },
    mounted() {   
        this.refreshAll();           
    },    
    data: function () {
        return {
            ClassCatList:[],
            ClassTeacherList:[],
            ClassCodeList:[],
            ClassSeqList:[],
            ClassAnnualList:[],
            currentClassGroup:'',
            currentClassCode:'',
            currentClassSeq:'',
            currentClassAnnual:'',
            selectedField: 'selected',
            selectedID: 1,
            currentPage:1,
            skip: 0,
            take: 10,     
            ClassInfos:[],
            ClassInfoEdit:
            {
                guid:'',
                classGroup:'',
                classCode:'',
                classAnnual:'',
                classCatName:'',
                className:'',
                classSeq:'',
                classStartDate:'',
                classEndDate:'',
                classDays:'',
                classHours:'',
                classLocation:'',
                classContent:'',
                targetStudents:'',
                tuition:'',
                tuitionMemo:'',
                provideMeal:'',
                mealMemo:'',
                provideAccommodation:'',
                accommodationFee:'',
                accommodationMemo:'',
                show:'',
                giveCourse:'',
                teacher:'',
                       
            },                     
            ClassInfoAdd:
            {
                classGroup:'',
                classCode:'',
                classCatName:'',
                className:'',
                classSeq:'',
                classAnnual:'',
                classStartDate:'',
                classEndDate:'',
                classDays:'',
                classHours:'',
                classLocation:'',
                classContent:'',
                tuition:0,
                tuitionMemo:'',
                provideMeal:'是',
                mealMemo:'',
                provideAccommodation:'否',
                accommodationFee:0,
                accommodationMemo:'',
                show:'否',                             
                giveCourse:'',
                teacher:'',
            },   
            ClassLocations:[],         
            guid:'',
            };
    },
    computed: {
      columns() {
          return [
                { cell: 'myTemplate', width: '165px' },
                { hidden: true, field: 'guid', title: 'guid', width: '100px' },
                { field: 'classGroup', title: '類別代碼' , width: this.setPercentage(20)},
                { field: 'classCatName', title: '類別名稱', width: this.setPercentage(20) },
                { field: 'classCode', title: '課程代碼' , width: this.setPercentage(20)},
                { field: 'classAnnual', title: '課程年度' , width: this.setPercentage(20)},
                { field: 'className', title: '課程名稱' , width: this.setPercentage(20)},
                { field: 'classLocation', title: '地點', width: this.setPercentage(20) },          
                { field: 'classStartDate', title: '課程日期起', width: this.setPercentage(20),type: "date",format: "{0:yyyy-MM-dd}" },      
                { field: 'classEndDate', title: '課程日期迄', width: this.setPercentage(20) ,type: "date",format: "{0:yyyy-MM-dd}"},          
          ];
      },        
        items () {
            return this.ClassInfos.map((item) => ({ ...item, selected: item.guid === this.selectedID }));
        },
        selectedItem () {
            return this.ClassInfos.find((item) => item.guid === this.guid);
        },
        result: {
            get: function() {
                return this.ClassInfos.slice(this.skip, this.take + this.skip);
            }
        },    
        total () {
            return this.ClassInfos.totalRows;
        },           
    },
    methods: {
        edit(dataItem) {
            this.ClassInfoEdit = dataItem;
            this.ClassInfoEdit.classStartDate = moment(this.ClassInfoEdit.classStartDate).format('YYYY-MM-DD');
            this.ClassInfoEdit.classEndDate = moment(this.ClassInfoEdit.classEndDate).format('YYYY-MM-DD');            
            this.$bvModal.show('bv-modal');            
        },        
        remove(dataItem) {
            axios.delete(this.$httpPath+'/ClassInfo/DeleteClassInfo',{params: dataItem})
                .then((response) => {
                    if(response.status==200)
                    {
                        Vue.$toast.open({
                        message: '刪除完成。',
                        position: 'bottom-right',
                        type: 'success'
                        });                            
                    }   
                    else
                    {
                        Vue.$toast.open({
                        message: '刪除錯誤。',
                        position: 'top',
                        type: 'error'
                        });   
                    }
                })
                .catch((error) => {
                        Vue.$toast.open({
                        message: '刪除錯誤。',
                        position: 'top',
                        type: 'error'
                        });   
                }).finally(() => {
            }); 

           axios.get(this.$httpPath+'/NewsItem/GetNewsItemsEdit', {
            params:{
                title: this.newsTitle,
                currentPage:this.currentPage,
                pageSize:this.take
            }})
            .then((response)=>{
                if(response.status===200)
                {
                    this.News=response.data;
                }
            })
        },
        /*duplicate(dataItem) {
            axios.delete(this.$httpPath+'/ClassInfo/DeleteClassInfo',{params: dataItem})
                .then((response) => {
                    if(response.status==200)
                    {
                        Vue.$toast.open({
                        message: '複製完成。',
                        position: 'bottom-right',
                        type: 'success'
                        });                            
                    }   
                    else
                    {
                        Vue.$toast.open({
                        message: '複製錯誤。',
                        position: 'top',
                        type: 'error'
                        });   
                    }
                })
                .catch((error) => {
                        Vue.$toast.open({
                        message: 'catch複製錯誤。',
                        position: 'top',
                        type: 'error'
                        });   
                }).finally(() => {
            }); 

           axios.get(this.$httpPath+'/NewsItem/GetNewsItemsEdit', {
            params:{
                title: this.newsTitle,
                currentPage:this.currentPage,
                pageSize:this.take
            }})
            .then((response)=>{
                if(response.status===200)
                {
                    this.News=response.data;
                }
            })
        },*/
        
        ClassCat_Modal_onChange(event)
        {
            this.ClassInfoAdd.classGroup = event.target.value
        },      
        refreshGrid()
        {
            this.gridWidth = this.$refs.divWrapper.offsetWidth;   
            axios.get(this.$httpPath+'/ClassInfo/GetClassInfosPage', {
                params:{
                    classCode: "",
                    currentPage:this.currentPage,
                    pageSize:this.take
                }})
                .then((response)=>{
                    if(response.status===200)
                    {
                        this.ClassInfos=response.data;
                    }
                })
        },  
        refreshClassLocations()
        {
            axios.get(this.$httpPath+'/ClassLocation/GetClassLocations')
                .then((response) => {
                    if(response.status==200)
                    {
                        this.ClassCatLocations =  response.data;
                        this.ClassCatLocations.splice(0, 0, "");                    
                    }   
                    else
                    {
                        Vue.$toast.open({
                        message: '上課地點查詢錯誤。',
                        position: 'top',
                        type: 'error'
                        });   
                    }
                })
                .catch((error) => {
                        Vue.$toast.open({
                        message: '上課地點查詢錯誤。',
                        position: 'top',
                        type: 'error'
                        });   
                }).finally(() => {
            });
        },
        refreshClassCats()
        {
            axios.get(this.$httpPath+'/ClassCat/GetClassCats')
                .then((response) => {
                    if(response.status==200)
                    {
                        this.ClassCatList =  response.data;
                        this.ClassCatList.splice(0, 0, "");                    
                    }   
                    else
                    {
                        Vue.$toast.open({
                        message: '課程類別代碼查詢錯誤。',
                        position: 'top',
                        type: 'error'
                        });   
                    }
                })
                .catch((error) => {
                        Vue.$toast.open({
                        message: '課程類別代碼查詢錯誤。',
                        position: 'top',
                        type: 'error'
                        });   
                }).finally(() => {
            });  
        }, 
        refreshClassTeacher()
        {
            axios.get(this.$httpPath+'/Teacher/GetTeacherNameList')
                .then((response) => {
                    if(response.status==200)
                    {
                        this.ClassTeacherList =  response.data;
                        this.ClassTeacherList.splice(0, 0, "");                    
                    }   
                    else
                    {
                        Vue.$toast.open({
                        message: '講師查詢錯誤。',
                        position: 'top',
                        type: 'error'
                        });   
                    }
                })
                .catch((error) => {
                        Vue.$toast.open({
                        message: '講師查詢錯誤。',
                        position: 'top',
                        type: 'error'
                        });   
                }).finally(() => {
            });  
        }, 
        refreshClassCode()
        {
            axios.get(this.$httpPath+'/ClassInfo/GetClassCode')
                .then((response) => {
                    if(response.status==200)
                    {
                        this.ClassCodeList =  response.data;
                        this.ClassCodeList.splice(0, 0, "");                    
                    }   
                    else
                    {
                        Vue.$toast.open({
                        message: '課程代碼查詢錯誤。',
                        position: 'top',
                        type: 'error'
                        });   
                    }
                })
                .catch((error) => {
                        Vue.$toast.open({
                        message: '課程代碼查詢錯誤Catch。',
                        position: 'top',
                        type: 'error'
                        });   
                }).finally(() => {
            });  
        }, 
        refreshClassSeq()
        {
            axios.get(this.$httpPath+'/ClassInfo/GetClassSeq')
                .then((response) => {
                    if(response.status==200)
                    {
                        this.ClassSeqList =  response.data;
                        this.ClassSeqList.splice(0, 0, "");                    
                    }   
                    else
                    {
                        Vue.$toast.open({
                        message: '班別序號查詢錯誤。',
                        position: 'top',
                        type: 'error'
                        });   
                    }
                })
                .catch((error) => {
                        Vue.$toast.open({
                        message: '班別序號查詢錯誤Catch。',
                        position: 'top',
                        type: 'error'
                        });   
                }).finally(() => {
            });  
        }, 
        refreshClassAnnual()
        {
            axios.get(this.$httpPath+'/ClassInfo/GetClassAnnual')
                .then((response) => {
                    if(response.status==200)
                    {
                        this.ClassAnnualList =  response.data;
                        this.ClassAnnualList.splice(0, 0, "");                    
                    }   
                    else
                    {
                        Vue.$toast.open({
                        message: '班別年度查詢錯誤。',
                        position: 'top',
                        type: 'error'
                        });   
                    }
                })
                .catch((error) => {
                        Vue.$toast.open({
                        message: '班別年度查詢錯誤Catch。',
                        position: 'top',
                        type: 'error'
                        });   
                }).finally(() => {
            });  
        }, 
        refreshAll()
        {
            this.refreshClassCats();
            this.refreshGrid();
            this.refreshClassLocations();
            this.refreshClassCode();
            this.refreshClassSeq();
            this.refreshClassAnnual();
            this.refreshClassTeacher();
        },     
        CancelAdd()
        {     
            this.ClassInfoAdd.classGroup='';
            this.ClassInfoAdd.classCode='';
            this.ClassInfoAdd.classCatName='';
            this.ClassInfoAdd.className='';
            this.ClassInfoAdd.classSeq='';
            this.ClassInfoAdd.classAnnual='';
            this.ClassInfoAdd.classStartDate='';
            this.ClassInfoAdd.classEndDate='';
            this.ClassInfoAdd.classDays='';
            this.ClassInfoAdd.classHours='';
            this.ClassInfoAdd.classLocation='';
            this.ClassInfoAdd.classContent='';
            this.ClassInfoAdd.tuition=0;
            this.ClassInfoAdd.tuitionMemo='';
            this.ClassInfoAdd.provideMeal='是';
            this.ClassInfoAdd.mealMemo='';
            this.ClassInfoAdd.provideAccommodation='否';
            this.ClassInfoAdd.accommodationFee=0;
            this.ClassInfoAdd.accommodationMemo='';
            this.ClassInfoAdd.show='否';
            this.refreshGrid();      
        },   
        CancelEdit()
        {     
            this.refreshGrid();      
        },          
        ClassCat_onChange_Add(event)
        {
            axios.get(this.$httpPath+'/ClassCat/GetClassCatName?catID='+event.target.value)
            .then((response) => {
                if(response.status==200)
                {
                    this.ClassInfoAdd.classCatName= response.data;     
                }     
            })        
        },   
        ClassTeacher_onChange_Add(event)
        {
            axios.get(this.$httpPath+'/Teacher/GetTeacher?guid='+event.target.value)
            .then((response) => {
                if(response.status==200)
                {
                    this.ClassInfoAdd.teacher= response.data;     
                }     
            })        
        },        
        remove(dataItem) {
            axios.delete(this.$httpPath+'/ClassInfo/DeleteClassInfo',{params: dataItem})
                .then((response) => {
                    if(response.status==200)
                    {
                        Vue.$toast.open({
                        message: '刪除完成。',
                        position: 'bottom-right',
                        type: 'success'
                        }); 
                        this.refreshGrid();                           
                    }   
                    else
                    {
                        Vue.$toast.open({
                        message: '刪除錯誤。',
                        position: 'top',
                        type: 'error'
                        });   
                    }
                })
                .catch((error) => {
                        Vue.$toast.open({
                        message: '刪除錯誤Catch。'+error,
                        position: 'top',
                        type: 'error'
                        });   
                }).finally(() => {
            }); 

           this.searchClassInfo();
        },
        giveClass(dataItem) {
            window.location.href = '/#/GiveClassSys?classCat='+dataItem.classGroup+'&classId='+dataItem.classCode;
        },
        printDoc(dataItem){
            window.location.href = '/#/DocMergePrint?classCat='+dataItem.classGroup+'&classId='+dataItem.classCode+'&classGuid='+dataItem.guid;
        },
        duplicate(dataItem) {
            axios.delete(this.$httpPath+'/ClassInfo/DuplicateClassInfo',{params: dataItem})
                .then((response) => {
                    if(response.status==200)
                    {
                        Vue.$toast.open({
                        message: '複製完成。',
                        position: 'bottom-right',
                        type: 'success'
                        }); 
                        this.refreshGrid();                           
                    }   
                    else
                    {
                        Vue.$toast.open({
                        message: '複製錯誤。',
                        position: 'top',
                        type: 'error'
                        });   
                    }
                })
                .catch((error) => {
                        Vue.$toast.open({
                        message: '複製錯誤Catch。'+error,
                        position: 'top',
                        type: 'error'
                        });   
                }).finally(() => {
            }); 

           this.searchClassInfo();
        },
        
        setPercentage (percentage) {
            return Math.round(this.gridWidth / 100) * percentage;
        },         
        onSubmit: async function () 
        {
            const isValid = await this.$validator.validateAll();
            if(isValid)
            {                 
                axios.put(this.$httpPath+'/ClassInfo/UpdateClassInfo',this.ClassInfoEdit)
                    .then((response) => {
                        if(response.status==200)
                        {
                            Vue.$toast.open({
                            message: '更新完成。',
                            position: 'bottom-right',
                            type: 'success'
                            });    
                            this.refreshGrid();                        
                        }   
                        else
                        {
                            Vue.$toast.open({
                            message: '更新錯誤。',
                            //message: 'Error'+response.status,
                            position: 'top',
                            type: 'error'
                            });   
                        }
                    })
                    .catch((error) => {
                            Vue.$toast.open({
                            message: '更新錯誤catch error。'+error+"_response",
                            position: 'top',
                            type: 'error'
                            });   
                    }).finally(() => {
                }); 
            }
            this.refreshGrid();
        },        
        onSubmitAddNews: async function () 
        {
            //const isValid = await this.$validator.validateAll();
            //if(isValid)
            {                            
                axios.post(this.$httpPath+'/ClassInfo/AddClassInfo',this.ClassInfoAdd)
                     .then((response) => {
                        if(response.status==200)
                        {
                            Vue.$toast.open({
                            message: '新增完成。',
                            position: 'bottom-right',
                            type: 'success'
                            });
                            this.refreshGrid();                        
                        }   
                        else
                        {
                            Vue.$toast.open({
                            message: '新增錯誤。',
                            position: 'top',
                            type: 'error'
                            });   
                        }
                    })
                    .catch((error) => {
                            Vue.$toast.open({
                            message: '新增錯誤。',
                            position: 'top',
                            type: 'error'
                            });   
                    }).finally(() => {
                }); 
            }
        },  
        searchClassInfo()
        {
            axios.get(this.$httpPath+'/ClassInfo/GetClassInfosPage', {
                params:{
                    classCode: this.currentClassCode,
                    classGroup: this.currentClassGroup,
                    classSeq: this.currentClassSeq,
                    classAnnual: this.currentClassAnnual,
                    currentPage:this.currentPage,
                    pageSize:this.take
                }})
                .then((response)=>{
                    if(response.status===200)
                    {
                        this.ClassInfos=response.data;
                    }
                })
        },    
        OpenAddNews (event) {
            this.$bvModal.show('bv-modal-add-news');
        }, 
        onFileChange(fileList) {
            this.files.append("file", fileList[0], fileList[0].name);
        },           
        pageChangeHandler: function(event) {  
            this.currentPage = (event.page.skip/this.take)+1,
            this.skip = event.page.skip;
            this.take = event.page.take;
            axios.get(this.$httpPath+'/ClassInfo/GetClassInfosPage', {
                params:{
                    currentClassCode:this.currentClassCode,
                    currentPage:this.currentPage,
                    pageSize:this.take
                }})
                .then((response)=>{
                    if(response.status===200)
                    {
                        this.ClassInfos=response.data;
                    }
                })
                          
        },
    },
};
</script>
<style>
    @import "../../assets/css/telerik/all.css";
    .k-header {
        font-size: 16px; /* Sets icon size to 32px */
    }   
</style>