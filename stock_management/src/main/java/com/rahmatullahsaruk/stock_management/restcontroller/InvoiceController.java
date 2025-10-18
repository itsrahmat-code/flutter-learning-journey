package com.rahmatullahsaruk.stock_management.restcontroller;

import com.rahmatullahsaruk.stock_management.dto.InvoiceDTO;
import com.rahmatullahsaruk.stock_management.entity.Invoice;
import com.rahmatullahsaruk.stock_management.mapper.InvoiceMapper;
import com.rahmatullahsaruk.stock_management.service.InvoiceService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@CrossOrigin(origins = "*")
@RestController
@RequestMapping("/api/invoices")
public class InvoiceController {

    @Autowired
    private InvoiceService invoiceService;

    // ✅ Create Invoice
    @PostMapping
    public ResponseEntity<InvoiceDTO> createInvoice(@RequestBody InvoiceDTO invoiceDTO) {
        Invoice invoice = InvoiceMapper.toEntity(invoiceDTO);
        // Stock deduction, snapshot creation, and total calculation happens in the service layer
        Invoice saved = invoiceService.save(invoice);
        return ResponseEntity.ok(InvoiceMapper.toDTO(saved));
    }

    // ✅ Get All Invoices
    @GetMapping
    public ResponseEntity<List<InvoiceDTO>> getAllInvoices() {
        List<InvoiceDTO> invoices = invoiceService.getAll()
                .stream()
                .map(InvoiceMapper::toDTO)
                .collect(Collectors.toList());
        return ResponseEntity.ok(invoices);
    }

    // ✅ Get Invoice by ID
    @GetMapping("/{id}")
    public ResponseEntity<InvoiceDTO> getInvoiceById(@PathVariable Long id) {
        Optional<Invoice> invoiceOpt = invoiceService.getById(id);
        return invoiceOpt.map(invoice -> ResponseEntity.ok(InvoiceMapper.toDTO(invoice)))
                .orElse(ResponseEntity.notFound().build());
    }

    // ✅ Update Invoice
    @PutMapping("/{id}")
    public ResponseEntity<InvoiceDTO> updateInvoice(@PathVariable Long id, @RequestBody InvoiceDTO invoiceDTO) {
        Optional<Invoice> optionalInvoice = invoiceService.getById(id);
        if (optionalInvoice.isEmpty()) {
            return ResponseEntity.notFound().build();
        }

        Invoice existing = optionalInvoice.get();
        Invoice updatedData = InvoiceMapper.toEntity(invoiceDTO); // This contains the new list of products/line items

        // ✅ Update fields to match new entity
        existing.setCustomerName(updatedData.getCustomerName());
        existing.setCustomerEmail(updatedData.getCustomerEmail());
        existing.setCustomerPhone(updatedData.getCustomerPhone());
        existing.setCustomerAddress(updatedData.getCustomerAddress());
        existing.setDiscount(updatedData.getDiscount());
        existing.setTaxRate(updatedData.getTaxRate());
        existing.setPaid(updatedData.getPaid());

        // Replace products (line items)
        existing.getProducts().clear();
        if (updatedData.getProducts() != null) {
            // CRITICAL: Ensure the back-reference is set for all new line items
            updatedData.getProducts().forEach(p -> p.setInvoice(existing));
            existing.getProducts().addAll(updatedData.getProducts());
        }

        // Recalculate totals (necessary since products, discount, or taxRate might have changed)
        existing.calculateTotals();

        // Note: The service layer's current 'save' method skips stock deduction for updates (id != null),
        // which is a simplification we're keeping.
        Invoice saved = invoiceService.save(existing);
        return ResponseEntity.ok(InvoiceMapper.toDTO(saved));
    }

    // ✅ Delete Invoice
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteInvoice(@PathVariable Long id) {
        Optional<Invoice> invoiceOpt = invoiceService.getById(id);
        if (invoiceOpt.isEmpty()) {
            return ResponseEntity.notFound().build();
        }
        invoiceService.delete(id);
        return ResponseEntity.noContent().build();
    }
}