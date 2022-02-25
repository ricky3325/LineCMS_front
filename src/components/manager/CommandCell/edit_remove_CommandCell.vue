<template>
<td>       
    <button
        class="k-button k-grid-edit-command"
        @click="editHandler"
    >
      編輯
    </button>

    <button
        class="k-button k-grid-remove-command"
        @click="removeHandler"
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
        editHandler: function() {
            this.$emit('edit', this.dataItem);
        },    
        removeHandler: function() {
            if(confirm('確認刪除 ?')){
               this.$emit('remove', this.dataItem);
            }
        },
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