package com.shoplite.models;

import com.shoplite.shop.statics.Constants;
import com.shoplite.shop.statics.Constants.PAYMENTMode;

public class PaymentDetail {

	int orderId;
	double amount;
	int referenceNumber;
	Constants.PAYMENTMode mode;
	int paymentID;
	
	public PaymentDetail(int orderId, double amount, int referenceNumber,
			PAYMENTMode mode) {
		super();
		this.orderId = orderId;
		this.amount = amount;
		this.referenceNumber = referenceNumber;
		this.mode = mode;
	}
	
	public int getOrderId() {
		return orderId;
	}
	public void setOrderId(int orderId) {
		this.orderId = orderId;
	}
	public double getAmount() {
		return amount;
	}
	public void setAmount(double amount) {
		this.amount = amount;
	}
	public int getReferenceNumber() {
		return referenceNumber;
	}
	public void setReferenceNumber(int referenceNumber) {
		this.referenceNumber = referenceNumber;
	}
	public Constants.PAYMENTMode getMode() {
		return mode;
	}
	public void setMode(Constants.PAYMENTMode mode) {
		this.mode = mode;
	}
}
