<template>
<k-dialog @close="cancel">
                <div :style="{ marginBottom: '1rem' }">
                    <label>
                    文件說明<br />
                    <k-input
                        style="width:400px"
                        type="text"
                        :name="'文件說明'"
                        v-model= "fileItemInEdit.文件說明"
                        :blur="checkDescription()"
                    ></k-input>
                    </label>
                </div>
                <div :style="{ marginBottom: '1rem' }">
                    <label>上傳檔案</label>
                    <upload
                        :disabled="isDisabled"
                        :auto-upload="false"
                        :default-files="[]"
                        :with-credentials="false"
                        :multiple="false"
                        @beforeupload="onBeforeUpload"
                        :restrictions="{
                            allowedExtensions: ['.doc','docx']
                        }"
                        :save-url="this.$httpPath+'/QualityControlDocTemplate/UploadFileAsync'">
                    </upload>
                    <div class="k-form-hint">檔案格式: <strong> doc/docx</strong></div>                   
                </div>              
            <dialog-actions-bar>
                <button
                    class="k-button"
                    @click="cancel"
                >
                    離開
                </button>
            </dialog-actions-bar>
        </k-dialog>
</template>
<script>
import { Dialog, DialogActionsBar } from '@progress/kendo-vue-dialogs';
import { Input } from '@progress/kendo-vue-inputs';
import { Upload } from '@progress/kendo-vue-upload';
export default {
   name:"QualityControlDoc_DialogContainer_Upload",
   components: {
        'k-input': Input,
        'k-dialog': Dialog,
        'dialog-actions-bar': DialogActionsBar,   
        upload: Upload,        
    },
   props: {
      dataItem: Object
  },
  data: function(){
    return {
        fileItemInEdit: {
            guid:'',                
            文件說明:'',
            檔案名稱:''  
        },    
        isDisabled:true,  
    };
  },
  created: function(){
    if(this.$props.dataItem){
      this.fileItemInEdit = this.$props.dataItem;
    }
  },
  methods: {
      isNullOrWhitespace( input ) {
        if (typeof input === 'undefined' || input == null) return true;
        return input.replace(/\s/g, '').length < 1;
      },
      checkDescription()
      {
        if(this.isNullOrWhitespace(this.fileItemInEdit.文件說明))
            this.isDisabled=true; 
        else
            this.isDisabled=false; 
      },
      onBeforeUpload(event) {
        event.additionalData.文件說明 = this.fileItemInEdit.文件說明;
      },           
      select(fileName)
      {
        this.fileItemInEdit.檔案名稱=fileName;
      },
      cancel(){
        this.$emit('CancelUpload');
      },
  },
}

</script>

