<template>
<td>
    <button
        class="k-button k-grid-download-command"
        @click="DownloadHandler"
    >
        下載
    </button>       
    <button
        class="k-button k-grid-edit-command"
        @click="ApprovalHandler"
    >
      簽核
    </button>

    <button
        class="k-button k-grid-remove-command"
        @click="RemoveHandler"
    >
        刪除
    </button>
 
</td>
</template>
<script>

export default {
   props: {
        field: String,
        dataItem: Object,
        format: String,
        className: String,
        columnIndex: Number,
        columnsCount: Number,
        rowType: String,
        level: Number,
        expanded: Boolean,
        editor: String
    },
    methods: {
        ApprovalHandler: function() {
            this.$emit('ApprovalHandler', this.dataItem);
        },
        DownloadHandler: function() {
            this.$emit('DownloadHandler', this.dataItem);
        },        
        RemoveHandler: function() {
            if(confirm('確認刪除 ?')){
               this.$emit('RemoveHandler', this.dataItem);
            }
        }
    }
}
</script>
<style scoped>
.k-grid-download-command
{
    color: white;
    background-color: #283B42;
}
.k-grid-edit-command
{
    color: white;
    background-color: #1D6A96;
}
.k-grid-remove-command
{
    color: white;
    background-color: #85b8cb;
}
</style>