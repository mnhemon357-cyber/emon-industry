public class EfirmInvoice {
    public static void main(String[] args) {
        double serviceFee = 15000.0;
        double vat = serviceFee * 0.05;
        System.out.println("[EFIRM JAVA] Total Payable: BDT " + (serviceFee + vat));
    }
}
