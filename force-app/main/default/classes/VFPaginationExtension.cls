public class VFPaginationExtension {
    public VFPaginationExtension(ApexPages.StandardSetController setController) {
        setController.setPageSize(100);
    }
}